module Main exposing (..)

import Browser
import Colors
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import Html exposing (Html)
import Http
import Json.Decode as JD exposing (Decoder, Error(..), field, string)



--MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



--MODEL


type Model
    = ViewingWelcome
    | LoadingQuiz
    | ViewingQuiz Quiz
    | LoadingScore
    | ViewingScore
    | Failure



--Failure String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ViewingWelcome
    , Cmd.none
    )


type Msg
    = ViewWelcome
    | ViewQuiz
    | ViewScore
    | GotQuiz (Result Http.Error Quiz)


type alias Quiz =
    List Question


type alias Question =
    { question : String
    , options : List Option
    , selectedOption : Maybe Char
    }


type alias Option =
    { id : String
    , text : String
    }



--UPDATE


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewWelcome ->
            ( ViewingWelcome, Cmd.none )

        ViewQuiz ->
            ( LoadingQuiz, getQuiz )

        ViewScore ->
            ( ViewingScore, Cmd.none )

        GotQuiz result ->
            case result of
                Ok quiz ->
                    ( ViewingQuiz quiz, Cmd.none )

                Err _ ->
                    ( Failure, Cmd.none )



--VIEW


view : Model -> Html Msg
view model =
    layout [ inFront header ]
        (quizMenu model)


header : Element msg
header =
    row
        [ Region.heading 1
        , width fill
        , centerX
        , alignTop
        , padding 20
        , Background.gradient { angle = 3.14, steps = [ Colors.black, Colors.black, Colors.black, Colors.green ] }
        , Border.color (rgb255 235 235 235)
        , Border.width 2
        , Border.rounded 5
        ]
        [ el [ centerX, Font.color Colors.orange ] (text "MG's pub quiz 🍻") ]


questionDisplay question =
    column
        [ spacing 20
        , centerX
        , centerY
        , Font.color Colors.orange
        ]
        [ el [] (text question.question)
        ]


quizMenu : Model -> Element Msg
quizMenu model =
    case model of
        ViewingWelcome ->
            row
                [ width fill
                , height fill
                , centerX
                , centerY
                ]
                [ column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
                , column
                    [ width (fillPortion 8)
                    , height fill
                    , spacing 20
                    , Background.color Colors.black
                    ]
                    [ column
                        [ centerX
                        , centerY
                        , Font.color Colors.orange
                        , spacing 10
                        ]
                        [ el [ centerX ] (text "Welcome to the Pub quiz!")
                        , Input.button
                            [ Background.color Colors.white
                            , Font.color Colors.orange
                            , centerX
                            , padding 5
                            , Border.color Colors.orange
                            , Border.width 1
                            , Border.rounded 10
                            , Element.focused
                                [ Background.color Colors.greyBrown ]
                            ]
                            { onPress = Just ViewQuiz
                            , label = text "Click here to enter."
                            }
                        ]
                    ]
                , column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
                ]

        ViewingQuiz quiz ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
                , column
                    [ width (fillPortion 8)
                    , height fill
                    , spacing 20
                    , Background.color Colors.black
                    ]
                    (List.map (\question -> questionDisplay question) quiz)
                , column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
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

        LoadingQuiz ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Loading Quiz, Please wait...") ]
                , column [ width (fillPortion 1) ] []
                ]

        LoadingScore ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Loading Score, Please wait...") ]
                , column [ width (fillPortion 1) ] []
                ]

        Failure ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Something went wrong :(") ]
                , column [ width (fillPortion 1) ] []
                ]



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
    Sub.none



--HTTP


getQuiz : Cmd Msg
getQuiz =
    Http.get
        { url = "http://localhost:9090/api/quiz/"
        , expect = Http.expectJson GotQuiz quizDecoder
        }


quizDecoder : Decoder (List Question)
quizDecoder =
    field "quiz" (JD.list questionDecoder)


questionDecoder : Decoder Question
questionDecoder =
    JD.map3 Question
        (field "question" string)
        (field "options" optionsDecoder)
        (JD.succeed Nothing)


optionsDecoder : Decoder (List Option)
optionsDecoder =
    JD.list optionDecoder


optionDecoder : Decoder Option
optionDecoder =
    JD.map2 Option
        (field "id" string)
        (field "text" string)
