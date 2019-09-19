相关使用

    apscheduler.schedulers.base.BaseScheduler.remove_all_jobs
    apscheduler.schedulers.base.BaseScheduler.add_job(jobstore='default')
    
    直接使用就报错了，因为没有添加 jobstore
    
    apscheduler.schedulers.base.BaseScheduler.add_jobstore
    def add_jobstore(self, jobstore, alias='default', **jobstore_opts):
        :param str|unicode|apscheduler.jobstores.base.BaseJobStore jobstore: job store to be added
    jobstore 是必填的，默认是什么呢？
    
    查看
    apscheduler.schedulers.base.BaseScheduler.add_job
        jobstore='default'
    apscheduler.schedulers.base.BaseScheduler._real_add_job
        store = self._lookup_jobstore(jobstore_alias)
    apscheduler.schedulers.base.BaseScheduler._lookup_jobstore
        return self._jobstores[alias]
    apscheduler.schedulers.base.BaseScheduler.start    
        if 'default' not in self._jobstores:
            self.add_jobstore(self._create_default_jobstore(), 'default')
            
    apscheduler.schedulers.base.BaseScheduler._create_default_jobstore
        return MemoryJobStore()
        
    可以看到默认是 memory
    
    所以直接
    self.scheduler.add_jobstore('memory', TiebaSign.JOB_STORE_ERROR_RETRY)