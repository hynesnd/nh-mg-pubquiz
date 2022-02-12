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
import Json.Decode exposing (Error(..), field, int)
import Quiz exposing (Option, Question, Quiz, quizDecoder)



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
    | ViewingScore Int
    | Failure String


init : () -> ( Model, Cmd Msg )
init _ =
    ( ViewingWelcome
    , Cmd.none
    )



--UPDATE


type Msg
    = ViewWelcome
    | ViewQuiz
    | ViewScore
    | GotQuiz (Result Http.Error Quiz)
    | GotScore (Result Http.Error Int)
    | SelectAnswer Question String


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        ViewWelcome ->
            ( ViewingWelcome, Cmd.none )

        ViewQuiz ->
            ( LoadingQuiz, getQuiz )

        ViewScore ->
            case model of
                ViewingQuiz quiz ->
                    case List.map (\q -> Maybe.withDefault "No Answer" q.selectedOption) quiz of
                        [ answer1, answer2, answer3 ] ->
                            let
                                submittedAnswers =
                                    { answer1 = answer1
                                    , answer2 = answer2
                                    , answer3 = answer3
                                    }
                            in
                            ( LoadingQuiz, getScore submittedAnswers )

                        _ ->
                            ( Failure "Not all questions answered", Cmd.none )

                _ ->
                    ( Failure "Can't view score unless viewing quiz", Cmd.none )

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

        GotScore result ->
            case result of
                Ok score ->
                    ( ViewingScore score, Cmd.none )

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


pageFrame : Element msg -> Element msg
pageFrame content =
    row
        [ width fill
        , height fill
        , centerX
        , Background.color Colors.black
        ]
        [ column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
        , content
        , column [ width (fillPortion 1), height fill, Background.color Colors.orange ] []
        ]


quizMenu : Model -> Element Msg
quizMenu model =
    pageFrame <|
        case model of
            ViewingWelcome ->
                column
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

            ViewingQuiz quiz ->
                column
                    [ width (fillPortion 8)
                    , spacing 20
                    , Background.color Colors.black
                    ]
                <|
                    List.map questionDisplay quiz
                        ++ [ if Quiz.allQuestionsAnswered quiz then
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
                                    { onPress = Just ViewScore, label = text "Submit Answers" }

                             else
                                none
                           ]

            ViewingScore score ->
                column [ width (fillPortion 8) ]
                    [ column
                        [ centerX
                        , centerY
                        , Font.color Colors.orange
                        , spacing 10
                        , padding 10
                        , Background.color Colors.greyBrown
                        , Border.color Colors.orange
                        , Border.width 1
                        , Border.rounded 10
                        ]
                        [ if score == 2 then
                            text ("Your score is: " ++ String.fromInt score)

                          else if score > 2 then
                            text ("Congratulations! Your score is: " ++ String.fromInt score)

                          else
                            text ("Bad luck! Your score is: " ++ String.fromInt score)
                        ]
                    ]

            LoadingQuiz ->
                column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Loading Quiz, Please wait...") ]

            LoadingScore ->
                column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text "Loading Score, Please wait...") ]

            Failure errString ->
                column [ width (fillPortion 8) ]
                    [ el [ centerX ] (text ("Something went wrong :( " ++ errString)) ]



--SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



--HTTP


getQuiz : Cmd Msg
getQuiz =
    Http.get
        { url = "http://localhost:9090/api/quiz/"
        , expect = Http.expectJson GotQuiz quizDecoder
        }


getScore : { answer1 : String, answer2 : String, answer3 : String } -> Cmd Msg
getScore { answer1, answer2, answer3 } =
    Http.get
        { url = "http://localhost:9090/api/quiz/score?q1=" ++ answer1 ++ "&q2=" ++ answer2 ++ "&q3=" ++ answer3
        , expect = Http.expectJson GotScore (field "score" int)
        }
