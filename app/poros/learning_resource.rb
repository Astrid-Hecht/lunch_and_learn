class LearningResource
  attr_reader :country,
              :video,
              :images

  def initialize(country, video, images)
    @country = country
    @video = video
    @images = images
  end
end
