/*
 * JobInfo.java
 *
 * Created on June 18, 2003, 11:42 AM
 */

package com.sun.grid.drmaa;

import java.util.*;

/** The class represents the status and usage information for a job.  It should
 * be extended by an implementation for each specific DRM.
 * @author dan.templeton@sun.com
 */
public abstract class JobInfo implements java.io.Serializable {
	/** the id of the job this class describes */	
	protected String jobId;
	/** the status code for the job */	
	protected int status;
	/** a Map of resource usage data */	
	protected Map resourceUsage;
	
	/** Creates a new instance of JobInfo
	 * @param jobId the id of the job
	 * @param status the status code of the job
	 * @param resourceUsage the resource usage data for the job
	 */
	protected JobInfo (String jobId, int status, Map resourceUsage) {
		this.jobId = jobId;
		this.status = status;
		this.resourceUsage = new HashMap (resourceUsage);
	}
	
	/** Get the job id.
	 * @return the job id
	 */	
	public String getJobId () {
		return jobId;
	}

	/** Get the resource usage data.
	 * @return the resource usage data
	 */	
	public Map getResourceUsage () {
		return Collections.unmodifiableMap (resourceUsage);
	}
	
	/** Returns <CODE>true</CODE> if the job terminated normally.
	 * <CODE>False</CODE> can also indicate that
	 * although the job has terminated normally an exit status is not available
	 * or that it is not known whether the job terminated normally. In both
	 * cases getExitStatus() SHALL NOT provide exit status information.
	 * <CODE>True</CODE> indicates more detailed diagnosis can be provided
	 * by means of hasSignaled(), getTerminatingSignal() and hasCoreDump().
	 * @return if the job has exited
	 */	
	public abstract boolean hasExited ();
	
	/** If hasExited() returns true,  this function returns the exit code
	 * that the job passed to _exit() (see exit(2)) or exit(3C), or the value
	 * that the child process returned from main.
	 * @return the exit code for the job
	 */	
	public abstract int getExitStatus ();
	
	/** Returns <CODE>true</CODE> if the job terminated due to the receipt
	 * of a signal. <CODE>False</CODE> can also indicate that although the
	 * job has terminated due to the receipt of a signal the signal is not
	 * available or that it is not known whether the job terminated due to
	 * the receipt of a signal. In both cases getTerminatingSignal() SHALL
	 * NOT provide signal information.
	 * @return if the job exited on a signal
	 */	
	public abstract boolean hasSignaled ();
	
	/** If hasSignaled() returns true, this function evaluates into signal
	 * a string representation of the signal that caused the termination
	 * of the job. For signals declared by POSIX, the symbolic
	 * names SHALL be returned (e.g., SIGABRT, SIGALRM).<BR>
	 * For signals not declared by POSIX, any other string may be returned.
	 * @return the name of the terminating signal
	 */	
	public abstract String getTerminatingSignal ();
	
	/** If hasSignaled() returns true, this function returns true
	 * if a core image of the terminated job was created.
	 * @return whether a core dump image was created
	 */	
	public abstract boolean hasCoreDump ();
	
	/** Returns true if the job ended before entering the running state.
	 * @return whether the job ended before entering the running state
	 */	
	public abstract boolean wasAborted ();
}
