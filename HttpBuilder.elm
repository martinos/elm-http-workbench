module HttpBuilder (..) where

import Http exposing (..)
import Html exposing (table, td, tr, text, Html)


addVerb : String -> Request -> Request
addVerb verb request =
  { request | verb = verb }


addHeader : ( String, String ) -> Request -> Request
addHeader header request =
  { request | headers = (header :: request.headers) }


emptyRequest : Request
emptyRequest =
  { verb = "", headers = [], url = "", body = Http.string "" }


addHost : String -> Request -> Request
addHost host request =
  { request | url = host }


addPath : String -> Request -> Request
addPath path request =
  { request | url = request.url ++ path }


addQueries : List ( String, String ) -> Request -> Request
addQueries query request =
  { request | url = Http.url request.url query }

-- VIEW HELPER 

displayResponse : Response -> Html
displayResponse response =
  table
    []
    [ tr
        []
        [ td [] [ text "Status" ]
        , td [] [ text (response.status |> toString) ]
        ]
    , tr
        []
        [ td [] [ text "statusText" ]
        , td [] [ text (response.statusText |> toString) ]
        ]
    , tr
        []
        [ td [] [ text "headers" ]
        , td [] [ text (response.headers |> toString) ]
        ]
    , tr
        []
        [ td [] [ text "url" ]
        , td [] [ text (response.url) ]
        ]
    , tr
        []
        [ td [] [ text "value" ]
        , td [] [ text (response.value |> valueToString) ]
        ]
    ]


displayHttpResult : Result RawError Response -> Html
displayHttpResult result =
  case result of
    Ok response ->
      displayResponse response

    Err error ->
      error |> toString |> text


displayStringResult : Result a b -> Html
displayStringResult result =
  case result of
    Ok a ->
      a |> toString |> text 

    Err error ->
      error |> toString |> text 

valueToString : Http.Value -> String
valueToString value =
  case value of
    Text string ->
      string

    Blob _ ->
      "BLOB BOB"


