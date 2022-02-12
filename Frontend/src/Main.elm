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
import Http exposing (Error(..))
import Json.Decode as JD exposing (Decoder, Error(..), field, string)



--MAIN


main : Program () Model Msg
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
    | Failure String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ViewingWelcome
    , Cmd.none
    )


type alias Quiz =
    -- Consider a Dict for this? https://package.elm-lang.org/packages/elm/core/latest/Dict
    List Question


type alias Question =
    { question : String
    , options : List Option
    , selectedOption : Maybe String
    }


type alias Option =
    { id : String
    , text : String
    }



--UPDATE


type Msg
    = ViewWelcome
    | ViewQuiz
    | ViewScore
    | GotQuiz (Result Http.Error Quiz)
    | SelectAnswer Question String


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

                Err httpError ->
                    ( Failure <|
                        case httpError of
                            BadUrl errString ->
                                "Bad url: " ++ errString

                            Timeout ->
                                "Timeout"

                            NetworkError ->
                                "Network error"

                            BadStatus status ->
                                "Bad status: " ++ String.fromInt status

                            BadBody bodyString ->
                                "Bad Body: " ++ bodyString
                    , Cmd.none
                    )

        SelectAnswer question answerId ->
            case model of
                ViewingQuiz quiz ->
                    let
                        newQuiz =
                            List.map
                                (\q ->
                                    if question == q then
                                        { q | selectedOption = Just answerId }

                                    else
                                        q
                                )
                                quiz
                    in
                    ( ViewingQuiz newQuiz, Cmd.none )

                _ ->
                    ( Failure "Can't select option unless viewing quiz", Cmd.none )



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


questionDisplay : Question -> Element Msg
questionDisplay question =
    column
        [ spacing 10
        , padding 10
        , centerX
        , centerY
        , Font.color Colors.orange
        , Background.color Colors.greyBrown
        , Border.color Colors.orange
        , Border.width 1
        , Border.rounded 10
        ]
        [ el [] (text question.question)
        , row
            [ spacing 10
            , centerX
            ]
          <|
            List.map (optionDisplay question) question.options
        ]


optionDisplay : Question -> Option -> Element Msg
optionDisplay question option =
    let
        isSelected =
            case question.selectedOption of
                Nothing ->
                    False

                Just optionId ->
                    optionId == option.id
    in
    Input.button
        [ padding 5
        , Background.color <|
            if isSelected then
                Colors.orange

            else
                Colors.black
        , Font.color <|
            if isSelected then
                Colors.black

            else
                Colors.orange
        , Border.color Colors.orange
        , Border.width 1
        , Border.rounded 10
        ]
        { onPress =
            if isSelected then
                Nothing

            else
                Just <| SelectAnswer question option.id
        , label = text option.text
        }


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
            let
                allQuestionsAnswered =
                    List.all (\q -> q.selectedOption /= Nothing) quiz
            in
            row
                [ width fill
                , height fill
                , centerX
                , Background.color Colors.black
                ]
                [ column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
                , column
                    [ width (fillPortion 8)
                    , spacing 20
                    , Background.color Colors.black
                    ]
                  <|
                    List.map questionDisplay quiz
                        ++ [ if allQuestionsAnswered then
                                Input.button
                                    [ spacing 10
                                    , padding 10
                                    , centerX
                                    , centerY
                                    , Font.color Colors.orange
                                    , Background.color Colors.greyBrown
                                    , Border.color Colors.orange
                                    , Border.width 1
                                    , Border.rounded 10
                                    ]
                                    { onPress = Nothing, label = text "Submit Answers" }

                             else
                                none
                           ]
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

        Failure errString ->
            row
                [ width fill
                , height fill
                , centerX
                ]
                [ column [ width (fillPortion 1) ] []
                , column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text ("Something went wrong :( " ++ errString)) ]
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
