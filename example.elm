module Main (..) where

import HttpResponseApp
import HttpBuilder exposing (..)
import Json.Decode as JD exposing ((:=))
import Task
import Effects
import Http


app =
  HttpResponseApp.appForQuery
    [ ( "GET posts", getPosts [ ( "userId", "1" ) ] |> Task.toResult |> Task.map displayStringResult )
    , ( "GET post 1", getPost 1 |> Task.toResult |> Task.map displayHttpResult )
    , ( "POST post", postPosts |> Task.toResult |> Task.map displayHttpResult )
    -- , ( "GET repos", getRepos |> Task.toResult |> Task.map displayHttpResult )
      , ( "GET repos", getRepos |> Task.toResult |> Task.map displayStringResult )
    ]


main =
  app.html


port tasks : Signal (Task.Task Effects.Never ())
port tasks =
  app.tasks


host =
  emptyRequest |> addHost "http://jsonplaceholder.typicode.com"


getPosts queries =
  host
    |> addPath "/posts"
    |> addVerb "Get"
    |> addQueries queries
    |> Http.send Http.defaultSettings
    |> Http.fromJson postsDecoder


type alias Post =
  { id : Int, title : String, body : String }


postsDecoder =
  JD.list postDecoder


postDecoder =
  JD.object3 Post ("id" := JD.int) ("title" := JD.string) ("body" := JD.string)


getPost int =
  host
    |> addPath ("/posts/" ++ (toString int))
    |> addVerb "Get"
    |> Http.send Http.defaultSettings


postPosts =
  host
    |> addPath ("/posts/")
    |> addVerb "POST"
    |> Http.send Http.defaultSettings


github =
  emptyRequest |> addHost "https://api.github.com"


getRepos =
  github
    |> addPath "/users/martinos/repos"
    |> addVerb "GET"
    |> Http.send Http.defaultSettings
    |> Http.fromJson reposDecoder


type alias Repo =
  { id : Int, name : String, fullName : String }


reposDecoder =
  JD.list repoDecoder


repoDecoder =
  JD.object3
    Repo
    ("id" := JD.int)
    ("name" := JD.string)
    ("full_name" := JD.string)

