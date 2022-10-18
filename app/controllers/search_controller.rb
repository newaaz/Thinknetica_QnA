class SearchController < ApplicationController
  def search
    redirect_back fallback_location: root_path, notice: 'Type something in search field' if params[:search_query].empty?
        
    @resources = params[:resources].drop(1)   # drop, because first element always blank (i dont know why)
    query = params[:search_query]

    if @resources.size == 1
      @result = search_global_or_one(query)
    else
      @result = result_from_multiple(query)
    end
  end

  private

  def search_global_or_one(query)
    if @resources[0] == 'All'
      @result = result_from_global(query)
    else
      @result =  result_from_one(query)   
    end
  end

  def result_from_one(query)
    @resources[0].constantize.search query
  end

  def result_from_global(query)
    ThinkingSphinx.search query
  end

  def result_from_multiple(query)
    @resources.delete('All')

    result = []
    @resources.each do |resource|
      result_by_resource = resource.constantize.search query
      result.push result_by_resource
    end
    
    result
  end
end
