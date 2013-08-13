require 'simplecov'
SimpleCov.start
require 'test/unit'
require 'dtm'

class TestDtm < Test::Unit::TestCase
  def test_parameterize
    params = Dtm::Dtm.parameterize(:a_a => 'a', :b_b => {:c => true}, :d_d => [{:e_e => 'e'}, '/FF:f'])
    assert_equal("/AA:a /BB:/C:true /DD { /EE:e } /DD { /FF:f }", params)
  end
end