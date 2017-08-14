class Search
  RESOURCES = %w(All Questions Answers Comments Users).freeze

  def self.find(query, resource)
    return nil unless query.present?
    return nil unless RESOURCES.include?(resource)
    query = ThinkingSphinx::Query.escape(query)
    resource == 'All' ? ThinkingSphinx.search(query) : ThinkingSphinx.search(query, classes: [model_klass(resource)])
  end

  private

  def self.model_klass(resource)
    resource.classify.constantize
  end
end
