---
date: 2017-02-20 10:10
title: A New Start
tags: jekyll, microblog
published: True
---

In preparation for the [Micro Blog](https://micro.blog/) launch I have reworked my website infrastructure.  I wanted it to be static, easily updatable with markdown files, and backed up in some way outside of my own domain.  So I decided to try [Jekyll](https://jekyllrb.com).

### Initial Setup

- I created a clone of [Jekyll Now](https://github.com/barryclark/jekyll-now) to [My own repo](https://github.com/jamiejenkins/jamiejenkins.github.io).
- This automatically creates a [Github Pages](https://pages.github.com/)  as the [backup website](https://jamiejenkins.github.io/).
- I setup a [Linode](https://linode.com) server as the primary webserver.
- Created a deploy key for www-data user to do an automated git pull when I do a push to [GitHub](https://github.com).
- Added deploy.php to the public_html to handle the webhook from [GitHub](https://github.com).

### Posting workflow

- I can edit posts locally on server which are published with a git push to github.
- I can also do a jekyll build locally only to test which is exposed in a [subdirectory](https://jamiejenkins.com/local/) of the main [site](https://jamiejenkins.com).
- On iOS I'm using [Working Copy](https://workingcopyapp.com) and [Editorial](http://omz-software.com/editorial/) to change and push back to github.
  This in turn triggers the github webhook that runs the deploy.php on my server to do a git pull and jekyll build.
 
### Next Steps

- I may write up a more detailed post of all the steps in this setup at some point.
- Waiting for [Micro Blog](https://micro.blog) to launch so I can reserve my username!
- Customize the css and page layout a little bit.
