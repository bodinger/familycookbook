# module CDB
#   module Ran
#     module Healthcheck
#       include ::ContentApi::Core::Healthcheck
#
#       # Specific app checks
#       def get_first_regular(items)
#         regular_items = items.collect do |item|
#           unless item.top == 1
#             item
#           end
#         end.compact
#         regular_items.first
#       end
#
#       def get_most_recent_item_data(items)
#         most_recent = get_first_regular(items)
#         most_recent = items.first unless most_recent
#         diff        = Time.now.to_i - most_recent.published
#
#         if most_recent.published < items.first.published
#           most_recent = items.first
#           diff        = Time.now.to_i - items.first.published
#         end
#
#         most_recent_data_hash(most_recent, most_recent.published, diff)
#       end
#
#       def get_most_recent_livestream_data(items)
#         most_recent = get_first_regular(items)
#         most_recent = items.first unless most_recent
#         diff        = Time.now.to_i - most_recent.streamdate_start
#
#         if most_recent.streamdate_start < items.first.streamdate_start
#           most_recent = items.first
#           diff        = Time.now.to_i - items.first.streamdate_start
#         end
#
#         most_recent_data_hash(most_recent, most_recent.streamdate_start, diff)
#       end
#
#       def most_recent_data_hash(item, timestamp, diff)
#         data = {
#           :node_id                  => item.id,
#           :is_top                   => item.top,
#           :timestamp_human_readable => Time.at(timestamp).to_s,
#           :timestamp                => timestamp,
#           :age                      => diff,
#           :age_human_readable       => readable_period(diff),
#           :title                    => item.teaser.title
#         }
#         data[:clip_id] = item.video_id if item.respond_to?(:video_id)
#         data
#       end
#
#       def get_pagination(default_limit = 2)
#         # Limit to "number_of_prioritized_results + 1" so that we receive both of the possible most recent items
#         pagination_from_params(
#           :limit => 1,
#           :default_limit => default_limit
#         )
#       end
#
#       def healthcheck_age_news
#         items = CDB::Ran::News.all(get_pagination(4))
#         return get_most_recent_item_data(items)
#       end
#
#       def healthcheck_age_livestreams
#         items = CDB::Ran::Livestream.all(get_pagination)
#         return get_most_recent_livestream_data(items)
#       end
#
#       def healthcheck_age_videos
#         items = CDB::Ran::Video.all(get_pagination)
#         return get_most_recent_item_data(items)
#       end
#
#       def healthcheck_age_galleries
#         items = CDB::Ran::Gallery.all(get_pagination)
#         return get_most_recent_item_data(items)
#       end
#
#       def healthcheck_news_ran_de
#         filename = 'healthcheck_www_result.json'
#         failed_result = {
#           :timestamp                => 0,
#           :timestamp_human_readable => "",
#           :title                    => "",
#           :node_id                  => 0
#         }
#         return failed_result unless File.exist?(filename)
#         www_result = File.read(filename)
#         return failed_result unless www_result
#         Oj.load(www_result).with_indifferent_access
#       end
#
#     end
#
#   end
# end
#
# CDB::Ran::App.helpers CDB::Ran::Healthcheck