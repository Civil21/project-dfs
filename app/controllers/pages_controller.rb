# frozen_string_literal: true

class PagesController < ApplicationController
  def index; end

  def resize
    @n = params[:n].to_i
    @m = params[:m].to_i
  end

  def cal
    as = params[:table]
    @n = as[:n].to_i
    @m = as[:m].to_i
    # step 1
    @x_a = {}
    @f_a = {}
    # step 2
    @al_a = {}
    # step 3
    l = {}
    @r_a = {}
    # step 4
    w = {}
    # step 6
    v_a = {}
    t_a = {}
    sl = {}
    as[:us].each do |a_i, a|
      x = {}
      f = {}
      # pp "#{a_i}: #{a}"
      a.each do |k_i, k|
        # pp "#{k_i}: #{k}"
        if k_i == 'l'
          # step 3
          l[a_i.to_i] = k.to_f
        elsif k_i == 'w'
          # step 4
          w[a_i.to_i] = k.to_i
        elsif k_i == 'sl'
          # step 6
          sl[a_i.to_i] = k.to_i
        elsif k_i == 't'
          # step 6
          t_a[a_i.to_i] = k.to_i
        elsif k_i == 'v'
          # step 6
          v_a[a_i.to_i] = k.to_i
        else
          u = k[:u].to_f
          t = ret[k[:t].to_sym]
          x[k_i.to_i] = if u <= 0.5
                          Math.sqrt(u / 2) * (t.last - t.first) + t.first
                        else
                          t.second - Math.sqrt((1 - u) / 2) * (t.last - t.first)
          end
          f[k_i.to_i] = x[k_i.to_i] / 100
        end
      end
      # step 1
      @x_a[a_i.to_i] = x
      @f_a[a_i.to_i] = f
      # step 2
      @al_a[a_i.to_i] = f.values.sum.to_f / f.length
      # step 3
      @r_a[a_i.to_i] = @al_a[a_i.to_i] * l[a_i.to_i]
    end
    # step 4
    @v = {}
    w.each do |i, value|
      # p [i,value]
      @v[i.to_i] = value.to_f / w.values.sum
    end
    # p 'step 5'
    @y = {}
    @y[1] = 1 - 1.to_f / (1..@n).collect { |i| @v[i].to_f / (1 - @r_a[i]) }.sum
    @y[2] = 1 - (1..@n).collect { |i| (1 - @r_a[i])**@v[i] }.inject(1) { |res, value| res * value }
    @y[3] = 1 - (1..@n).collect { |i| @v[i] * (1 - @r_a[i]) }.sum
    @y[4] = 1 - Math.sqrt((1..@n).collect { |i| (@v[i] * (1 - @r_a[i]))**2 }.sum)
    @df_y = {}
    @y.each do |y, v|
      df_y.each do |df, value|
        if v > value[0] && v <= value[1]
          @df_y[y] = df
          break
        end
      end
    end
    # # step 6
    # #pp [sl,t_a,v_a]
    @s = {}
    @z = {}
    @u = {}
    (1..@n).each do |i|
      @s[i] = sl[i] * t_a[i] + v_a[i]
      # pp [@s[i], @r_a[i]]
      @z[i] = @s[i] * @r_a[i]
      a = @s[i].to_f * 0.1
      b = @s[i]
      @u[i] = if @z[i] <= a
                0
              elsif @z[i] > b
                1
              else
                (@z[i] - a).to_f / (b - a)
             end
    end
    # # step 7
    @o = {}
    (1..@n).each do |i|
      @o[i] = Math.exp(-((@r_a[i] - 1)**2 + (@r_a[i] - 1) * (@u[i] - 1) + (@u[i] - 1)**2))
    end
    # # step 8
    @y_r = {}
    @y_r[1] = 1 - 1.to_f / (1..@n).collect { |i| @v[i].to_f / (1 - @o[i]) }.sum
    @y_r[2] = 1 - (1..@n).collect { |i| (1 - @o[i])**@v[i] }.inject(1) { |res, value| res * value }
    @y_r[3] = 1 - (1..@n).collect { |i| @v[i] * (1 - @o[i]) }.sum
    @y_r[4] = 1 - Math.sqrt((1..@n).collect { |i| (@v[i] * (1 - @o[i]))**2 }.sum)
    @df_y_r = {}
    @y_r.each do |y, v|
      df_y.each do |df, value|
        if v > value[0] && v <= value[1]
          @df_y_r[y] = df
          break
        end
      end
    end
  end

  def ret
    { "M": [0, 20], "A": [20, 50], "H": [50, 80], "C": [80, 100] }
  end

  def df_y
    { "незначний ступінь ризику безпеки МІС аеропорту": [0, 0.1],
      "низький ступінь ризику безпеки МІС аеропорту": [0.1, 0.3],
      "середній ступінь ризику безпеки МІС аеропорту": [0.3, 0.5],
      "високий ступінь ризику безпеки МІС аеропорту": [0.5, 0.8],
      "граничний ступінь ризику безпеки МІС аеропорту": [0.8, 1] }
  end
end
