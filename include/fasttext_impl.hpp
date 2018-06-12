#pragma once

#include <real.h>
#include <fasttext.h>
#include <iostream>
#include <set>
#include <string>
#include <vector>
#include <matrix.h>
#include <queue>
#include <sstream>
#include<map>
#include <include/types.hpp>

class FastTextImpl {
    private:
        fasttext::FastText model;
        fasttext::Matrix sentenceVectors;
        std::vector<std::string> sentences;
        int n; //no sentences to suggest from
        int k = 10; // no of suggestions to give
    public:
        FastTextImpl(std::string model_file_path, std::string suggestions_file_path);
        vp_t getSuggestions(std::string query);
};


FastTextImpl::FastTextImpl(std::string model_file_path, std::string suggestions_file_path) {
    int n = 0;
    std::string sentence;

    std::cout << "loading model from " << model_file_path << " ..." << std::endl;
    this->model.loadModel(model_file_path);

    int dim = this->model.getDimension();
    std::ifstream suggestions(suggestions_file_path);

    while (suggestions.peek() != EOF) {
        std::getline(suggestions, sentence);
        this->sentences.push_back(sentence);
        n++;
    }
    this->n = n;
    fasttext::Matrix sentenceVectors(n+1, dim);
    this->model.precomputeSentenceVectors(sentenceVectors, suggestions);
    this->sentenceVectors = sentenceVectors;
    std::cout << "Model loaded successfully!" << std::endl;

}

vp_t FastTextImpl::getSuggestions(std::string query) {
    std::istringstream queryStream(query);
    std::vector<int32_t> line, labels;
    vp_t resultVector;

    std::priority_queue<std::pair<fasttext::real, std::string>> result = this->model.nnSent(this->k, this->n, this->sentences, this->sentenceVectors, queryStream);

    int32_t i = 0;
    while (i < 10 && result.size() > 0) {
        if (!std::isnan(result.top().first)) {
            phrase_t phrase(result.top().first, result.top().second, "");
            resultVector.push_back(phrase);
            i++;
        }
        result.pop();
    }
    return resultVector;
}