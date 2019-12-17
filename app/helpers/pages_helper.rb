# frozen_string_literal: true

module PagesHelper
  def gen_as(n, m)
    pp 'start'
    form_for(:table, url: cal_path, method: :get) do |f|
      [f.label(:n, 'Кількість активів'),
       f.number_field(:n, value: n, min: 1, max: 10, onChange: 'resize()'),
       f.label(:m, 'Кількість загроз'),
       f.number_field(:m, value: m, min: 1, max: 10, onChange: 'resize()'),
       f.label(:y, 'Метод міркування експертів'),
       f.number_field(:y, value: 2, min: 1, max: 4),
       f.fields_for(:t) do |s|
         [
           content_tag(:div, f.label('Наслідки загроз')),
           s.fields_for(:m) do |t|
             content_tag(:div) do
               [
                 t.number_field(0, value: 0, min: 0, max: 1, step: 0.1),
                 t.number_field(1, value: 0.4, min: 0, max: 1, step: 0.1),
                 t.label('M – мінімальні наслідки загрози')
               ].join(' ').html_safe
             end
           end,
           s.fields_for(:a) do |t|
             content_tag(:div) do
               [
                 t.number_field(0, value: 0.4, min: 0, max: 1, step: 0.1),
                 t.number_field(1, value: 0.6, min: 0, max: 1, step: 0.1),
                 t.label('A – середні наслідки загрози')
               ].join(' ').html_safe
             end
           end,
           s.fields_for(:h) do |t|
             content_tag(:div) do
               [
                 t.number_field(0, value: 0.6, min: 0, max: 1, step: 0.1),
                 t.number_field(1, value: 0.8, min: 0, max: 1, step: 0.1),
                 t.label('H – високі наслідки загрози')
               ].join(' ').html_safe
             end
           end,
           s.fields_for(:c) do |t|
             content_tag(:div) do
               [
                 t.number_field(0, value: 0.8, min: 0, max: 1, step: 0.1),
                 t.number_field(1, value: 1, min: 0, max: 1, step: 0.1),
                 t.label('C – критичні наслідки загрози')
               ].join(' ').html_safe
             end
           end
         ].join(' ').html_safe
       end,
       f.submit('Обрахувати', class: 'btn btn-primary', style: 'margin-bottom:10px'),
       f.fields_for(:us) do |s|
         content_tag :table do
           [content_tag(:tr,
                        [content_tag(:td, 'Aктив'),
                         content_tag(:td, 'Загроза'),
                         content_tag(:td, 'Наслідок реалізації'),
                         content_tag(:td, 'Ступінь можливості реалізації'),
                         content_tag(:td, 'Тяжкість наслідків інциденту'),
                         content_tag(:td, 'Вага активу'),
                         content_tag(:td, 'Прибуток роботи МІС (серверу) за годину (Євро)'),
                         content_tag(:td, 'Час відновлення роботи серверу (година)'),
                         content_tag(:td, 'Вартість відновлення роботи МІС (Євро)')].join(' ').html_safe),
            (1..n).collect { |i| gen_a(s, i, m) }.join(' ').html_safe].join(' ').html_safe
         end
       end].join(' ').html_safe
    end
  end

  def gen_a(f, a, m)
    f.fields_for(a.to_s) do |s|
      content_tag(:tr,
                  [content_tag(:td, a.to_s, rowspan: m),
                   gen_f(s, 1),
                   content_tag(:td, s.number_field(:l, value: 0.5, min: 0, max: 1, step: 0.1), rowspan: m),
                   content_tag(:td, s.number_field(:w, value: 1, min: 1, max: 100, step: 1), rowspan: m),
                   content_tag(:td, s.number_field(:sl, value: 0, min: 0, step: 100), rowspan: m),
                   content_tag(:td, s.number_field(:t, value: 1, min: 1, max: 24, step: 1), rowspan: m),
                   content_tag(:td, s.number_field(:v, value: 0, min: 0, step: 100), rowspan: m),
                   (2..m).collect { |i| content_tag(:tr, gen_f(s, i)) }.join(' ').html_safe].join(' ').html_safe)
    end
  end

  def gen_f(f, a)
    f.fields_for(a.to_s) do |s|
      [content_tag(:td, a.to_s),
       content_tag(:td, s.select(:t, ['M– мінімальні наслідки загрози', 'A– середні наслідки загрози', 'H– високі наслідки загрози', 'C– критичні наслідки загрози'])),
       content_tag(:td, s.number_field(:u, value: 0.4, min: 0, max: 1, step: 0.2))].join(' ').html_safe
    end
  end
end
