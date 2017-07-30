class ProductDatatable < AjaxDatatablesRails::Base

  def_delegators :@view, :link_to, :product_path

  def view_columns
    # Declare strings in this format: ModelName.column_name
    # or in aliased_join_table.column_name format
    @view_columns ||= {
      name: {source: 'Product.name'},
      types: {source: 'Product.types', orderable: false},
      categories: {source: 'Product.categories', orderable: false},
      sets: {source: 'Product.sets', orderable: false},
      codes: {source: 'Product.codes', orderable: false}
    }
  end

  def data
    records.map do |record|
      {
        name: link_to(record.name, product_path(record)),
        types: record.types.join(', '),
        categories: record.categories.join(', '),
        sets: record.sets.join(', '),
        codes: record.codes.join(', ')
      }
    end
  end

  private

  def get_raw_records
    Product.all
  end

  # ==== These methods represent the basic operations to perform on records
  # and feel free to override them

  # def filter_records(records)
  # end

  # def sort_records(records)
  # end

  # def paginate_records(records)
  # end

  # ==== Insert 'presenter'-like methods below if necessary
end
