require 'acceptance_helper'
ATTRIBUTES_SCOPE = %i[data attributes].freeze
RELATIONSHIPS_SCOPE = %i[data relationships].freeze

resource 'Comments' do
  header 'Accept', 'application/json'
  header 'Content-Type', 'application/json'
  response_field :id, 'The content of the comment', required: true, scope: [:data]
  response_field :type, 'The content of the comment', required: true, scope: [:data]
  response_field :content, 'The content of the comment', required: true, scope: ATTRIBUTES_SCOPE
  response_field :title, 'The title of the comment', required: true, scope: ATTRIBUTES_SCOPE
  response_field :id, 'Owner of the comment', required: true, scope: RELATIONSHIPS_SCOPE + [:author], method: :author_id
  response_field :type, 'must be ', required: true, scope: RELATIONSHIPS_SCOPE + [:author], method: :author_id
  response_field :post, 'Post where the comment is', required: true, scope: RELATIONSHIPS_SCOPE
  response_field :created_at, 'Time when the record was created', scope: ATTRIBUTES_SCOPE
  response_field :updated_at, 'Time when the record was updated', scope: ATTRIBUTES_SCOPE

  parameter :content, 'The content of the comment',  scope: ATTRIBUTES_SCOPE
  parameter :title, 'The title of the comment',  scope: ATTRIBUTES_SCOPE
  response_field :id, 'Owner of the comment',  scope: RELATIONSHIPS_SCOPE + [:author]
  response_field :type, 'must be ',  scope: RELATIONSHIPS_SCOPE + [:author]
  parameter :post, 'Post where the comment is', scope: RELATIONSHIPS_SCOPE

  # INDEX
  get '/comments' do
    explanation 'Comments are sent by readers of the Post.'

    example_request 'Retrieving all comments' do
      expect(status).to eql 200
    end
  end
  post '/comments' do

    describe 'with valid parameters' do
      let(:content) { 'My content' }
      let(:title) { 'My title' }
      let(:author) { 'My title' }

      example 'Creates a new comment' do
        do_request
        expect(response_body).to eq(json_item(Comment.last))
        expect(status).to eq(201)
      end
    end

    describe 'with invalid parameters' do
      let(:title) { nil }
      example 'Attempting to create a comment invalid parameters' do
        expect { do_request }.not_to(change { Comment.count })
      end
    end
  end

  patch '/comments/:id' do

    let(:comment) { Comment.create(content: 'test', title: 'test') }

    describe 'with valid parameters' do
      let(:id) { comment.id }
      let(:title) { 'Valid' }

      example 'Updating an existing comment with valid parameters' do
        expect { do_request }.to change { comment.reload.title }.from('test').to('Valid')
      end
    end

    describe 'with invalid parameters' do
      let(:id) { comment.id }
      let(:title) { nil }

      example 'Updating an existing comment with invalid parameters' do
        expect { do_request }.not_to(change { comment.reload.title })
      end

      example 'returns the error message', document: false do
        do_request
      end
    end

    describe 'with invalid id' do
      #    let(:id) { 'invalid' }
      #    let(:title) { nil }
      #    example 'Attempting to update a comment using an invalid id' do
      #      expect { do_request }.to raise_exception ActiveRecord::RecordNotFound
      #    end
    end
  end

  # DESTROY
  delete '/comments/:id' do
    let!(:comment) { Comment.create(content: 'test', title: 'test') }
    describe 'with a valid id' do
      let(:id) { comment.id }
      example 'Deleting an existing comment' do
        expect { do_request }.to change { Comment.count }.by(-1)
      end
    end

    #  describe 'with an invalid id' do
    #    let(:id) { 'invalid' }
    #    example 'Attempting to delete a comment using an invalid id' do
    #      expect { do_request }.to raise_exception ActiveRecord::RecordNotFound
    #    end
    #  end
  end

  # SHOW
  get '/comments/:id' do
    let!(:comment) { Comment.create(content: 'test', title: 'test') }
    describe 'with a valid id' do
      let(:id) { comment.id }
      example_request 'Retrieving a single comment with a valid id' do
        expect(status).to eql 200
      end
    end
    #  describe 'with a invalid id' do
    #    let(:id) { 'invalid' }
    #    example 'Retrieving a single comment with an invalid id' do
    #      expect { do_request }.to raise_exception ActiveRecord::RecordNotFound
    #    end
    #  end
  end

  protected

  def json_collection(collection)
    ActiveModel::Serializer::CollectionSerializer.new(collection, serializer: Api::V1::CarSerializer).to_json
  end

  def json_item(item)
    ActiveModelSerializers::SerializableResource.new(item, serializer: CommentSerializer).to_json
  end
end
