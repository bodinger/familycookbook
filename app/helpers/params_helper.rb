# module CDB
#   module Ran
#     module ParamsHelper
#
#       def pagination_from_params(options = {})
#         pagination = Pagination.new(config, params.slice('limit'), options)
#         if pagination.valid?
#           pagination
#         else
#           halt(400, { :error => pagination.errors.first }.to_json)
#         end
#       end
#
#     end
#
#   end
# end
#
# CDB::Ran::App.helpers CDB::Ran::ParamsHelper