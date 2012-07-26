class RemoveOldQueries
  def run
    ids = Query.where("created_at < ?", 30.days.ago)
    if ids.size > 0
      Query.destroy(ids)
      puts "#{ids.size} queries have been deleted"
      else 
        puts "No queries were old enough for deleting"
      end
    end
end