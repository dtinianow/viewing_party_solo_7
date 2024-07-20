class Review
  attr_reader :author, :content

  def initialize(params)
    @author = params['author']
    @content = params['content']
  end
end
