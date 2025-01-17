module ProductsHelper

  def types_title
    @product.types.length > 1 ? 'Tipos' : 'Tipo'
  end

  def categories_title
    @product.categories.length > 1 ? 'Categorías' : 'Categoría'
  end

  def sets_title
    @product.sets.length > 1 ? 'Géneros' : 'Género'
  end

  def codes_title
    @product.codes.length > 1 ? 'Códigos' : 'Código'
  end

  def correct_chart data, **options
    if @just_one
      options[:donut] = true
      pie_chart data, options
    else
      line_chart data, options
    end
  end

end
