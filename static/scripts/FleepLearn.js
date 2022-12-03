import contract from 'truffle-contract'
import testnetContractJson from "~/build/testnet/Learn.json"
import mainnetContractJson from "~/build/mainnet/Learn.json"
import Network from './Network'

// UNCOMPLETED

const FleepLearn = {
    INPUT_FORMAT: 1,
    RADIO_FORMAT: 2,
    CHECKBOX_FORMAT: 3,
    instance: null,
    network: Network.current() == 'true',
    abi: this.network ? mainnetContractJson : testnetContractJson,
    getInstance: async function() {
        if (this.instance != null) {
            return this.instance
        }

        if (typeof ethereum === 'undefined') return null

        const swapContract = contract(this.abi)
        swapContract.setProvider(ethereum)

        try {
            this.instance = await swapContract.deployed()
            return this.instance
        } catch (error) {
            console.log(error);
            return null
        }
    },
    generateResource: function(questions, answers, formats) {
        const generatedQuestions = []
        const generatedAnswers = []

        if (questions.length != answers.length) return null
        if (questions.length != formats.length) return null

        for (let index = 0; index < questions.length; index++) {
            const QA = this.generateQuestionAnswer(
                questions[index],
                answers[index],
                formats[index]
            )
            generatedQuestions.push(QA.question)
            generatedAnswers.push(QA.answer)
        }

        return {
            questions: generatedQuestions,
            answers: generatedAnswers
        }
    },
    generateQuestionAnswer: function(questions, answers, format) {
        if (format == this.INPUT_FORMAT) {
            return {
                question: questions[0],
                answer: answers[0].trim().toLowerCase()
            }
        }
        if (format == this.RADIO_FORMAT) {
            return {
                question: JSON.stringify(questions),
                answer: answers[0].trim().toLowerCase()
            }
        }
        if (format == this.CHECKBOX_FORMAT) {
            return {
                question: JSON.stringify(questions),
                answer: JSON.stringify(questions)
            }
        }
    },
    generateAnswer: function(answers, format) {
        if (format == this.INPUT_FORMAT) {
            return answers[0].trim().toLowerCase()
        }
        if (format == this.RADIO_FORMAT) {
            return answers[0].trim().toLowerCase()
        }
        if (format == this.CHECKBOX_FORMAT) {
            return JSON.stringify(questions)
        }
    }
}

export default FleepLearn