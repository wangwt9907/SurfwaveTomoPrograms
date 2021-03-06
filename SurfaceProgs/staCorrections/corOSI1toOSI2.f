c corOSI1toOSI2.f
c  use in conjuntion with sac macro brsortcut.m to correct misbehaving KCC1 
c  to equivalent of STS1 vertical response

c  Empirical correction - no significance to functional form of correction
c  which are just convenient, smooth fits to observed spectral transfer
c  functions.  CAUTION  - this should be believed only between period of 
c  16 s and 143 s where we have inversions for station corrections based
c  on uniform phase velocity and wave parameters


      character*80 f1a, f1p, f2a, f2p
      parameter (nmax = 655360)
      dimension x1(nmax), x2(nmax), x3(nmax), x4(nmax)      
      f1a = 'temp.am'
      f2a = 'tempf.am'
      f1p = 'temp.ph'
      f2p = 'tempf.ph' 
      pi = 3.1415928
      twopi = 2.0*pi
      tenlg = 2.302585
      
      call rsac1(f1a,x1,npts,beg,delf,nmax,nerr)
      call rsac1(f1p,x2,npts,beg,delf,nmax,nerr)
      if (npts.gt.nmax) then
         write(*,*)  'time series too long'
      end if
      do i = 2, npts       
        freq= delf*(i-1)
	flog = alog10(freq)
	x3(i) = x1(i)/(1.59*0.5) 
	if (freq.lt.0.0273) x3(i) = x1(i)/0.5/(29.76*freq + 0.774)
        x4(i) = x2(i) + twopi*(0.0996*flog + 0.0880)
	if (freq.lt. 0.0123) then
 	  x4(i) = x2(i) - twopi*(0.1008*flog + 0.2947)
        endif
      enddo
      x3(1) = 0.0
      x4(1) = 0.0
	call wsac0(f2a,xdummy,x3,nerr)
	call wsac0(f2p,xdummy,x4,nerr)
        close(unit=10)
	stop	
      end      
