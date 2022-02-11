module Main exposing (..)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Region as Region
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
    { state : State
    }


type State
    = ViewingWelcome
    | ViewingQuiz
    | ViewingScore


init : () -> ( Model, Cmd Msg )
init _ =
    ( { state = ViewingWelcome }, Cmd.none )


type Msg
    = ViewWelcome
    | ViewQuiz
    | ViewScore



--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewWelcome ->
            ( { model | state = ViewingWelcome }, Cmd.none )

        ViewQuiz ->
            ( { model | state = ViewingQuiz }, Cmd.none )

        ViewScore ->
            ( { model | state = ViewingScore }, Cmd.none )



--VIEW


view : Model -> Html Msg
view model =
    layout [ inFront header ]
        (quizMenu model)


header =
    row
        [ Region.heading 1
        , width fill
        , centerX
        , alignTop
        , padding 20
        , Background.color (rgb255 35 35 35)
        , Border.color (rgb255 235 235 235)
        , Border.width 2
        , Border.rounded 5
        ]
        [ el [ centerX ] (text "MG's pub quiz 🍻") ]


quizMenu model =
    case model.state of
        ViewingWelcome ->
            row
                [ width fill
                , centerX
                , centerY
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8), height fill, spacing 20 ]
                    [ el [ centerX, centerY ] (text "Welcome to the Pub quiz!")
                    ]
                , column [ width (fillPortion 1) ] []
                ]

        ViewingQuiz ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Quiz goes here") ]
                , column [ width (fillPortion 1) ] []
                ]

        ViewingScore ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Score goes here") ]
                , column [ width (fillPortion 1) ] []
                ]



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none
