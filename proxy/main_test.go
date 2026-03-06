package proxy

import (
	"testing"
)

func TestObjectKey(t *testing.T) {
	tests := []struct {
		name     string
		urlPath  string
		expected string
	}{
		{
			name:     "empty path adds /index.html",
			urlPath:  "",
			expected: "/index.html",
		},
		{
			name:     "root path adds index.html",
			urlPath:  "/",
			expected: "/index.html",
		},
		{
			name:     "path with .html extension is unchanged",
			urlPath:  "/index.html",
			expected: "/index.html",
		},
		{
			name:     "path with .css extension is unchanged",
			urlPath:  "/styles/main.css",
			expected: "/styles/main.css",
		},
		{
			name:     "path with file extension is unchanged",
			urlPath:  "/static/chunks/asdfasdfasdf.js",
			expected: "/static/chunks/asdfasdfasdf.js",
		},
		{
			name:     "path with no extension and no trailing slash adds /index.html",
			urlPath:  "/about",
			expected: "/about/index.html",
		},
		{
			name:     "path with trailing slash adds index.html",
			urlPath:  "/about/",
			expected: "/about/index.html",
		},
		{
			name:     "nested path without extension adds /index.html",
			urlPath:  "/blog/post",
			expected: "/blog/post/index.html",
		},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := objectKey(tt.urlPath, "index.html")
			if got != tt.expected {
				t.Errorf("objectKey(%q) = %q, want %q", tt.urlPath, got, tt.expected)
			}
		})
	}
}
