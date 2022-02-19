# require 'rails_helper'

# RSpec.describe "/answers", type: :request do

#   describe "GET /index" do
#     it "renders a successful response" do
#       Answer.create! valid_attributes
#       get answers_url, headers: valid_headers, as: :json
#       expect(response).to be_successful
#     end
#   end

#   describe "GET /show" do
#     it "renders a successful response" do
#       answer = Answer.create! valid_attributes
#       get answer_url(answer), as: :json
#       expect(response).to be_successful
#     end
#   end

#   describe "POST /create" do
#     context "with valid parameters" do
#       it "creates a new Answer" do
#         expect {
#           post answers_url,
#                params: { answer: valid_attributes }, headers: valid_headers, as: :json
#         }.to change(Answer, :count).by(1)
#       end

#       it "renders a JSON response with the new answer" do
#         post answers_url,
#              params: { answer: valid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:created)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end

#     context "with invalid parameters" do
#       it "does not create a new Answer" do
#         expect {
#           post answers_url,
#                params: { answer: invalid_attributes }, as: :json
#         }.to change(Answer, :count).by(0)
#       end

#       it "renders a JSON response with errors for the new answer" do
#         post answers_url,
#              params: { answer: invalid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end
#   end

#   describe "PATCH /update" do
#     context "with valid parameters" do
#       let(:new_attributes) {
#         skip("Add a hash of attributes valid for your model")
#       }

#       it "updates the requested answer" do
#         answer = Answer.create! valid_attributes
#         patch answer_url(answer),
#               params: { answer: new_attributes }, headers: valid_headers, as: :json
#         answer.reload
#         skip("Add assertions for updated state")
#       end

#       it "renders a JSON response with the answer" do
#         answer = Answer.create! valid_attributes
#         patch answer_url(answer),
#               params: { answer: new_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:ok)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end

#     context "with invalid parameters" do
#       it "renders a JSON response with errors for the answer" do
#         answer = Answer.create! valid_attributes
#         patch answer_url(answer),
#               params: { answer: invalid_attributes }, headers: valid_headers, as: :json
#         expect(response).to have_http_status(:unprocessable_entity)
#         expect(response.content_type).to match(a_string_including("application/json"))
#       end
#     end
#   end

#   describe "DELETE /destroy" do
#     it "destroys the requested answer" do
#       answer = Answer.create! valid_attributes
#       expect {
#         delete answer_url(answer), headers: valid_headers, as: :json
#       }.to change(Answer, :count).by(-1)
#     end
#   end
# end
