package main

import (
	"net/http"
	"testing"
)

// NOTE(spangler) this lets you hook into go's http.client.Do request to
// control what's returned, the server response, etc.
// ref: https://go.dev/src/net/http/client.go and look for `testHookClientDoResult`
var testHookClientDoResult func(*http.Request) (*http.Response, error)

func myTestHook(req *http.Request) (*http.Response, error) {
	if testHookClientDoResult != nil {
		return testHookClientDoResult(req)
	}
	return http.DefaultClient.Do(req)
}

type testHookTransport struct{}

func (t *testHookTransport) RoundTrip(req *http.Request) (*http.Response, error) {
	return myTestHook(req)
}

var cli = &http.Client{
	Transport: &testHookTransport{},
}

func Test_Foo(t *testing.T) {
	// NOTE(spangler): simulate successfully enabling an account
	testHookClientDoResult = func(req *http.Request) (*http.Response, error) {
		return &http.Response{
			StatusCode: http.StatusOK,
			Body:       nil,
		}, nil
	}
}
