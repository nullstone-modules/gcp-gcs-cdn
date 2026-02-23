package proxy

import (
	"fmt"
	"io"
	"log"
	"net/http"
	"os"
	"path"
	"strings"

	"github.com/GoogleCloudPlatform/functions-framework-go/functions"
)

var (
	logger = log.New(os.Stderr, "", 0)
)

func init() {
	functions.HTTP("CleanURLsProxy", HandleRequest)
}

func HandleRequest(w http.ResponseWriter, r *http.Request) {
	bucketName := os.Getenv("GCS_BUCKET_NAME")
	bucketObjectKey := objectKey(r.URL.Path)

	proxyUrl := *r.URL
	proxyUrl.Scheme = "http"
	proxyUrl.Host = fmt.Sprintf("%s.storage.googleapis.com", bucketName)
	proxyUrl.Path = bucketObjectKey

	resp, err := http.Get(proxyUrl.String())
	if err != nil {
		logger.Printf("Error reaching backend (url = %s): %s\n", proxyUrl.String(), err.Error())
		http.Error(w, "upstream error", http.StatusBadGateway)
		return
	}
	defer resp.Body.Close()

	for k, v := range resp.Header {
		for _, s := range v {
			w.Header().Add(k, s)
		}
	}
	w.WriteHeader(resp.StatusCode)
	logger.Printf("Served (request.url = %s, backend.url = %s, response.code = %d)\n", r.URL.Path, proxyUrl.String(), resp.StatusCode)
	io.Copy(w, resp.Body)
}

func objectKey(urlPath string) string {
	// If the request path has no file extension and doesn't end in `/`, add `.html` file extension
	hasFileExtension := path.Ext(path.Base(urlPath)) != ""
	hasTrailingSlash := strings.HasSuffix(urlPath, "/")
	if !hasFileExtension && !hasTrailingSlash {
		return urlPath + ".html"
	}
	return urlPath
}
