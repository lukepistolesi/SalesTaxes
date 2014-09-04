require_relative '../spec_helper'
require_relative '../../sales_taxes_app/configuration'

module SalesTaxesApp
  describe Configuration do

    describe :product_keywords_yml_file do
      it 'sets the default configuration yaml file' do
        expect(Configuration.instance.product_keywords_yml_file).to eql './resources/product_keywords.yml'
      end
    end

    describe :product_keywords_yml_file= do
      before :each do
        @original_file = Configuration.instance.product_keywords_yml_file
      end

      after :each do
        Configuration.instance.send :product_keywords_yml_file=, @original_file
      end

      it 'sets the path for the configuration file' do
        expected_path = 'some path'

        Configuration.instance.send :product_keywords_yml_file=, expected_path

        expect(Configuration.instance.product_keywords_yml_file).to eql expected_path
      end

      it 'reset the yaml variable' do
        Configuration.instance.instance_variable_set :@settings, Hash.new
        Configuration.instance.send :product_keywords_yml_file=, ''
        expect(Configuration.instance.instance_variable_get :@settings).to be_nil
      end
    end

    describe :settings do

      subject { Configuration.instance.settings }

      it 'loads the yaml file containing the settings' do
        Configuration.instance.instance_variable_set :@settings, nil
        expect(Configuration.instance).to receive :load_yaml
        subject
      end

      it 'does not reload the yaml' do
        Configuration.instance.instance_variable_set :@settings, Hash.new
        expect(Configuration.instance).not_to receive :load_yaml
        subject
      end
    end

    describe :load_yaml do

      let(:current_file) { 'Current file' }

      before :each do
        allow(YAML).to receive :load
        allow(File).to receive :new
        allow(File).to receive :expand_path
        allow(Configuration.instance).to receive :product_keywords_yml_file
      end

      subject { Configuration.instance.send :load_yaml }

      it 'expands the path of the current conf file' do
        allow(Configuration.instance).to receive(:product_keywords_yml_file).and_return current_file
        expect(File).to receive(:expand_path).with current_file
        subject
      end

      it 'access the configuration file' do
        allow(File).to receive(:expand_path).and_return current_file
        expect(File).to receive(:new).with current_file
        subject
      end

      it 'loads the yaml file currently set in the instance' do
        allow(File).to receive(:new).and_return current_file
        expect(YAML).to receive(:load).with current_file

        subject
      end
    end
  end
end
