module Quiz exposing (Option, Question, Quiz, allQuestionsAnswered, quizDecoder)

import Json.Decode as JD exposing (Decoder, Error(..), field, string)


type alias Quiz =
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


allQuestionsAnswered : Quiz -> Bool
allQuestionsAnswered quiz =
    List.all (\q -> q.selectedOption /= Nothing) quiz
