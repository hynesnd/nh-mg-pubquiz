module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Html exposing (Html)


--MAIN
main =
  Browser.element
    { init = init
    , update = update
    , subscriptions = subscriptions
    , view = view
    }

--MODEL
type alias Model =
  {state : State

  }

type State 
  = ViewingWelcome
  | ViewingQuiz
  | ViewingScore

init : () -> (Model, Cmd Msg)
init _ =
    ({ state = ViewingWelcome}, Cmd.none)
  
type Msg
  = ViewWelcome
  | ViewQuiz
  | ViewScore


--UPDATE
update : Msg -> Model -> (Model, Cmd Msg)
update msg model =
  case msg of
    ViewWelcome ->
      ({model | state = ViewingWelcome}, Cmd.none)
    ViewQuiz ->
      ({model | state = ViewingQuiz}, Cmd.none)
    ViewScore ->
      ({model | state = ViewingScore}, Cmd.none)
--VIEW
view : Model -> Html Msg
view model =
  layout []
    quizMenu


quizMenu =
  row [ width fill
      , centerX
      ] 
    [ column [width (fillPortion 1)] []
    , column [width (fillPortion 8)] [el [centerX] (text "Hello World")]
    , column [width (fillPortion 1)] []

  ]


--SUBSCRIPTIONS

subscriptions : Model -> Sub Msg
subscriptions model =
  Sub.none