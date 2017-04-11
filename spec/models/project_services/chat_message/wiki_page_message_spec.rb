require 'spec_helper'

describe ChatMessage::WikiPageMessage, models: true do
  subject { described_class.new(args) }

  let(:args) do
    {
      user: {
        name: 'Test User',
        username: 'test.user',
        avatar_url: 'http://someavatar.com'
      },
      project_name: 'project_name',
      project_url: 'http://somewhere.com',
      object_attributes: {
        title: 'Wiki page title',
        url: 'http://url.com',
        content: 'Wiki page description'
      }
    }
  end

  context 'without markdown' do
    describe '#pretext' do
      context 'when :action == "create"' do
        before { args[:object_attributes][:action] = 'create' }

        it 'returns a message that a new wiki page was created' do
          expect(subject.pretext).to eq(
            'test.user created <http://url.com|wiki page> in <http://somewhere.com|project_name>: '\
              '*Wiki page title*')
        end
      end

      context 'when :action == "update"' do
        before { args[:object_attributes][:action] = 'update' }

        it 'returns a message that a wiki page was updated' do
          expect(subject.pretext).to eq(
            'test.user edited <http://url.com|wiki page> in <http://somewhere.com|project_name>: '\
              '*Wiki page title*')
        end
      end
    end

    describe '#attachments' do
      let(:color) { '#345' }

      context 'when :action == "create"' do
        before { args[:object_attributes][:action] = 'create' }

        it 'returns the attachment for a new wiki page' do
          expect(subject.attachments).to eq([
            {
              text: "Wiki page description",
              color: color,
            }
          ])
        end
      end

      context 'when :action == "update"' do
        before { args[:object_attributes][:action] = 'update' }

        it 'returns the attachment for an updated wiki page' do
          expect(subject.attachments).to eq([
            {
              text: "Wiki page description",
              color: color,
            }
          ])
        end
      end
    end
  end

  context 'with markdown' do
    before do
      args[:markdown] = true
    end

    describe '#pretext' do
      context 'when :action == "create"' do
        before { args[:object_attributes][:action] = 'create' }

        it 'returns a message that a new wiki page was created' do
          expect(subject.pretext).to eq(
            'test.user created [wiki page](http://url.com) in [project_name](http://somewhere.com): *Wiki page title*')
        end
      end

      context 'when :action == "update"' do
        before { args[:object_attributes][:action] = 'update' }

        it 'returns a message that a wiki page was updated' do
          expect(subject.pretext).to eq(
            'test.user edited [wiki page](http://url.com) in [project_name](http://somewhere.com): *Wiki page title*')
        end
      end
    end

    describe '#attachments' do
      context 'when :action == "create"' do
        before { args[:object_attributes][:action] = 'create' }

        it 'returns the attachment for a new wiki page' do
          expect(subject.attachments).to eq('Wiki page description')
        end
      end

      context 'when :action == "update"' do
        before { args[:object_attributes][:action] = 'update' }

        it 'returns the attachment for an updated wiki page' do
          expect(subject.attachments).to eq('Wiki page description')
        end
      end
    end

    describe '#activity' do
      context 'when :action == "create"' do
        before { args[:object_attributes][:action] = 'create' }

        it 'returns the attachment for a new wiki page' do
          expect(subject.activity).to eq({
            title: 'test.user created [wiki page](http://url.com)',
            subtitle: 'in [project_name](http://somewhere.com)',
            text: 'Wiki page title',
            image: 'http://someavatar.com'
          })
        end
      end

      context 'when :action == "update"' do
        before { args[:object_attributes][:action] = 'update' }

        it 'returns the attachment for an updated wiki page' do
          expect(subject.activity).to eq({
            title: 'test.user edited [wiki page](http://url.com)',
            subtitle: 'in [project_name](http://somewhere.com)',
            text: 'Wiki page title',
            image: 'http://someavatar.com'
          })
        end
      end
    end
  end
end
