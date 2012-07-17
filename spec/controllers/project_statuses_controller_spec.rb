require 'spec_helper'
describe ProjectStatusesController do
  let!(:project) { TravisProject.create!(name: "foo", feed_url: "http://travis-ci.org/account/project/builds.json") }
  let(:payload) {
      '{
   "id":1885645,
   "repository":{
      "id":96210,
      "name":"projectmonitor",
      "owner_name":"pivotal",
      "url":"https://github.com/pivotal/projectmonitor"
   },
   "number":"75",
   "config":{
      "language":"ruby",
      "bundler_args":"--without postgres development",
      "notifications":{
         "email":[
            "common-effort@pivotallabs.com"
         ],
         "webhooks":[
            "http://abhx.t.proxylocal.com/projects/459/project_statuses/"
         ]
      },
      "rvm":[
         "1.9.3"
      ],
      "before_script":[
         "bundle exec rake travis:setup",
         "export DISPLAY=:99",
         "sh -e /etc/init.d/xvfb start"
      ],
      "script":"bundle exec rake travis",
      ".result":"configured",
      "env":[

      ]
   },
   "status":1,
   "result":1,
   "status_message":"Broken",
   "result_message":"Broken",
   "started_at":"2012-07-17T14:16:37Z",
   "finished_at":"2012-07-17T14:18:52Z",
   "duration":135,
   "build_url":"http://travis-ci.org/pivotal/projectmonitor/builds/1885645",
   "commit":"5bbadf792613cb64cfc67e15ae620ea3cb56b81d",
   "branch":"webhooks",
   "message":"WIP",
   "compare_url":"https://github.com/pivotal/projectmonitor/compare/4420e39ce3c9...5bbadf792613",
   "committed_at":"2012-07-17T14:16:18Z",
   "author_name":"Andrew Fader & Mark Gangl",
   "author_email":"pair+afader+mgangl@pivotallabs.com",
   "committer_name":"Andrew Fader & Mark Gangl",
   "committer_email":"pair+afader+mgangl@pivotallabs.com",
   "matrix":[
      {
         "id":1885646,
         "repository_id":96210,
         "parent_id":1885645,
         "number":"75.1",
         "state":"finished",
         "config":{
            "language":"ruby",
            "bundler_args":"--without postgres development",
            "notifications":{
               "email":[
                  "common-effort@pivotallabs.com"
               ],
               "webhooks":[
                  "http://abhx.t.proxylocal.com/projects/459/project_statuses/"
               ]
            },
            "rvm":"1.9.3",
            "before_script":[
               "bundle exec rake travis:setup",
               "export DISPLAY=:99",
               "sh -e /etc/init.d/xvfb start"
            ],
            "script":"bundle exec rake travis",
            ".result":"configured"
         },
         "status":1,
         "result":1,
         "commit":"5bbadf792613cb64cfc67e15ae620ea3cb56b81d",
         "branch":"webhooks",
         "message":"WIP",
         "compare_url":"https://github.com/pivotal/projectmonitor/compare/4420e39ce3c9...5bbadf792613",
         "committed_at":"2012-07-17T14:16:18Z",
         "author_name":"Andrew Fader & Mark Gangl",
         "author_email":"pair+afader+mgangl@pivotallabs.com",
         "committer_name":"Andrew Fader & Mark Gangl",
         "committer_email":"pair+afader+mgangl@pivotallabs.com",
         "log":""
      }
   ]
}'
  }
  describe "#create" do
    subject { post :create, project_id: project.id, payload: payload }
    it "should create a new status" do
      expect { subject }.to change(ProjectStatus, :count).by(1)
    end

    it "should have all the attributes" do
      subject
      ProjectStatus.last.should_not be_success
      ProjectStatus.last.project_id.should == project.id
      ProjectStatus.last.published_at.should == Time.parse("2012-07-17T14:18:52Z")
    end
  end
end
