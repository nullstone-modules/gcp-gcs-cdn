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
	defaultDocument := os.Getenv("DEFAULT_DOCUMENT")
	bucketObjectKey := objectKey(r.URL.Path, defaultDocument)

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

func objectKey(urlPath, defaultDocument string) string {
	// If the request path has a file extension, this proxy acts as a pass-through
	if hasFileExtension := path.Ext(path.Base(urlPath)) != ""; urlPath != "" && hasFileExtension {
		return urlPath
	}

	// If the request path has no trailing slash, add it
	if hasTrailingSlash := strings.HasSuffix(urlPath, "/"); !hasTrailingSlash {
		urlPath += "/"
	}

	// Add <default_document> to the end of the request path
	return urlPath + defaultDocument
}
