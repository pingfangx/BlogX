>本文由平方X发表于平方X网，转载请注明出处。[http://blog.pingfangx.com/2439.html](http://blog.pingfangx.com/2439.html)

以前的发帖代码都是从网上找的，现在可以自己分析了。

# 发帖
由发帖按钮  
forum.php?mod=post&action=newthread&fid=45&extra=&topicsubmit=yes

转到  
source/module/forum/forum_post.php
```
if($_GET['action'] == 'newthread' || $_GET['action'] == 'newtrade') {
	loadcache('groupreadaccess');
	$navtitle .= ' - '.$_G['forum']['name'];
	require_once libfile('post/newthread', 'include');
} elseif($_GET['action'] == 'reply') {
	$navtitle .= ' - '.$thread['subject'].' - '.$_G['forum']['name'];
	require_once libfile('post/newreply', 'include');
} elseif($_GET['action'] == 'edit') {
	loadcache('groupreadaccess');
	$navtitle .= ' - '.$thread['subject'].' - '.$_G['forum']['name'];
	require_once libfile('post/editpost', 'include');
}

然后到
source/include/post/post_newthread.php

	$modthread = C::m('forum_thread');
    ...
	$return = $modthread->newthread($params);
	$tid = $modthread->tid;
	$pid = $modthread->pid;
到
source/class/model/model_forum_thread.php

		$newthread = array(
			'fid' => $this->forum['fid'],
			'posttableid' => 0,
			'readperm' => $this->param['readperm'],
			'price' => $this->param['price'],
			'typeid' => $this->param['typeid'],
			'sortid' => $this->param['sortid'],
			'author' => $author,
			'authorid' => $this->member['uid'],
			'subject' => $this->param['subject'],
			'dateline' => $this->param['publishdate'],
			'lastpost' => $this->param['publishdate'],
			'lastposter' => $author,
			'displayorder' => $this->param['displayorder'],
			'digest' => $this->param['digest'],
			'special' => $this->param['special'],
			'attachment' => 0,
			'moderated' => $this->param['moderated'],
			'status' => $this->param['tstatus'],
			'isgroup' => $this->param['isgroup'],
			'replycredit' => $this->param['replycredit'],
			'closed' => $this->param['closed'] ? 1 : 0
		);
        1,插入主题
		$this->tid = C::t('forum_thread')->insert($newthread, true);
        2,更新最新主题
		C::t('forum_newthread')->insert(array(
		    'tid' => $this->tid,
		    'fid' => $this->forum['fid'],
		    'dateline' => $this->param['publishdate'],
		));

        用户家园的最近行为记录
		if(!$this->param['isanonymous']) {
			C::t('common_member_field_home')->update($this->member['uid'], array('recentnote'=>$this->param['subject']));
		}

        3,插入帖子
		$this->pid = insertpost(array(
			'fid' => $this->forum['fid'],
			'tid' => $this->tid,
			'first' => '1',
			'author' => $this->member['username'],
			'authorid' => $this->member['uid'],
			'subject' => $this->param['subject'],
			'dateline' => $this->param['publishdate'],
			'message' => $this->param['message'],
			'useip' => $this->param['clientip'] ? $this->param['clientip'] : getglobal('clientip'),
			'port' => $this->param['remoteport'] ? $this->param['remoteport'] : getglobal('remoteport'),
			'invisible' => $this->param['pinvisible'],
			'anonymous' => $this->param['isanonymous'],
			'usesig' => $this->param['usesig'],
			'htmlon' => $this->param['htmlon'],
			'bbcodeoff' => $this->param['bbcodeoff'],
			'smileyoff' => $this->param['smileyoff'],
			'parseurloff' => $this->param['parseurloff'],
			'attachment' => '0',
			'tags' => $this->param['tagstr'],
			'replycredit' => 0,
			'status' => $this->param['pstatus']
		));
        
        
function insertpost($data) {
	if(isset($data['tid'])) {
		$thread = C::t('forum_thread')->fetch($data['tid']);
		$tableid = $thread['posttableid'];
	} else {
		$tableid = $data['tid'] = 0;
	}
	$pid = C::t('forum_post_tableid')->insert(array('pid' => null), true);


	$data = array_merge($data, array('pid' => $pid));

	C::t('forum_post')->insert($tableid, $data);
	if($pid % 1024 == 0) {
		C::t('forum_post_tableid')->delete_by_lesspid($pid);
	}
	savecache('max_post_id', $pid);
	return $pid;
}

                更新积分
				updatepostcredits('+',  $this->member['uid'], 'post', $this->forum['fid']);
                ...
				$subject = str_replace("\t", ' ', $this->param['subject']);
				$lastpost = "$this->tid\t".$subject."\t".TIMESTAMP."\t$author";
                更新版块的最后发表
				C::t('forum_forum')->update($this->forum['fid'], array('lastpost' => $lastpost));
                更新数量，包括 $threads , $posts , $todayposts =
				C::t('forum_forum')->update_forum_counter($this->forum['fid'], 1, 1, 1);
				if($this->forum['type'] == 'sub') {
					C::t('forum_forum')->update($this->forum['fup'], array('lastpost' => $lastpost));
				}
            ...
			C::t('forum_sofa')->insert(array('tid' => $this->tid,'fid' => $this->forum['fid']));

```


# 编辑帖子
```
source/module/forum/forum_post.php
source/include/post/post_editpost.php


	$modpost = C::m('forum_post', $_G['tid'], $pid);
		$modpost->editpost($param);

source/class/model/model_forum_post.php
            更新主题
			C::t('forum_thread')->update($this->thread['tid'], $this->param['threadupdatearr'], true);
        更新帖子
		C::t('forum_post')->update('tid:'.$this->thread['tid'], $this->post['pid'], $setarr);
        更新最后发表
		if($this->post['dateline'] == $this->forum['lastpost'][2] && ($this->post['author'] == $this->forum['lastpost'][3] || ($this->forum['lastpost'][3] == '' && $this->post['anonymous']))) {
			$lastpost = $this->thread['tid']."\t".($isfirstpost ? $this->param['subject'] : $this->thread['subject'])."\t".$this->post['dateline']."\t".($this->param['isanonymous'] ? '' : $this->post['author']);
			C::t('forum_forum')->update($this->forum['fid'], array('lastpost' => $lastpost));

		}
```
# 回帖、删帖
都在source/class/model/model_forum_post.php