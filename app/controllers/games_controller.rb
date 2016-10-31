class GamesController < ApplicationController

  def game
    @grid = generate_grid
    @start_time = Time.now.to_i
  end




  def score
    @guess = params[:guess]
    @grid = params[:grid]
    @start_time = params[:start_time].to_i
    @end_time = Time.now.to_i
    time = @end_time - @start_time
    translation = get_translation(@guess)

    @score, @message = score_and_message(@guess, translation, @grid, time)

  end

  private

  def included?(guess, grid)
    guess.split.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def generate_grid(grid_size=9)
    Array.new(grid_size) { ('A'..'Z').to_a[rand(26)] }
  end

  def compute_score(attempt, time_taken)
    (time_taken > 60.0) ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  # def run_game(attempt, grid, start_time, end_time)
  #   result = { time: end_time - start_time }

  #   result[:translation] = get_translation(attempt)
  #   result[:score], result[:message] = score_and_message(
  #     attempt, result[:translation], grid, result[:time])

  #   result
  # end

  def score_and_message(attempt, translation, grid, time)
    if included?(attempt.upcase, grid)
      if translation
        score = compute_score(attempt, time)
        [score, "well done"]
      else
        [0, "not an english word"]
      end
    else
      [0, "not in the grid"]
    end
  end

  def get_translation(word)
    # api_key = "YOUR_SYSTRAN_API_KEY"
    # begin
    #   response = open("https://api-platform.systran.net/translation/text/translate?source=en&target=fr&key=#{api_key}&input=#{word}")
    #   json = JSON.parse(response.read.to_s)
    #   if json['outputs'] && json['outputs'][0] && json['outputs'][0]['output'] && json['outputs'][0]['output'] != word
    #     return json['outputs'][0]['output']
    #   end
    # rescue
    if File.read('/usr/share/dict/words').upcase.split("\n").include? word.upcase
      return word
    else
      return nil
    end
  end
end
