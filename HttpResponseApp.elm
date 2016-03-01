module HttpResponseApp (..) where

import Html exposing (..)
import Html.Events exposing (..)
import Http
import StartApp exposing (..)
import HttpBuilder exposing (..)
import Effects
import Task


type alias Model =
  { result : Html, queries : List ( String, Effects.Effects Action ) }


view address model =
  div
    []
    [ div [] (model.queries |> List.map (queryButton address))
    , model.result
    ]


queryButton : Signal.Address Action -> ( String, Effects.Effects Action ) -> Html
queryButton address ( name, effect ) =
  button [ onClick address (Query effect) ] [ text name ]


type Action
  = NoOp
  | Response Html
  | Query (Effects.Effects Action)


update : Action -> Model -> ( Model, Effects.Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    Response result ->
      ( { model | result = result }, Effects.none )

    Query effect ->
      ( model, effect )


model : Model
model =
  { result = text "", queries = [] }


appForQuery queries =
  let
    queryAssocToEffects ( name, query ) =
      ( name, query |> Task.map Response |> Effects.task )
  in
    StartApp.start
      { init =
          ( { model
              | queries = queries |> List.map queryAssocToEffects
            }
          , Effects.none
          )
      , update = update
      , view = view
      , inputs = []
      }

