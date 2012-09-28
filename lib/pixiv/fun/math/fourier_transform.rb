=begin
フーリエ変換を行うためのクラス
=end
require 'complex'

module Pixiv
	module Fun
		module Mathematics
			class FourierTransform
				# 逆フーリエ変換、スペクトルを信号に直す
				def self.Inverse(spectrum)
					signals = Array.new(spectrum.length * 2, 0)	# 信号
					t = 1.0 / signals.length
					pi2 = 2.0 * Math::PI
					dpi2 = 1.0 / pi2
					
					for time in 1..signals.length do
						for freq in 1..spectrum.length do
							signals[time-1] += Math::sin(time * t * pi2 * freq) * spectrum[freq-1]
						end
						signals[time-1] *= dpi2
					end
					signals
				end
			end
		end
	end
end