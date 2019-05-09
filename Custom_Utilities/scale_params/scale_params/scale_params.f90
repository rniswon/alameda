!  scale_params.f90 
!
!  FUNCTIONS:
!  scale_params - Entry point of console application.
!

!****************************************************************************
!
!  PROGRAM: scale_params
!
!  PURPOSE:  Entry point for the console application.
!
!****************************************************************************

    program scale_params

    implicit none

    ! Variables
    CHARACTER(LEN=80) line 
    CHARACTER(LEN=40) line2
    INTEGER LLOC,ISTART,ISTOP,I,out,IN,numvals,inscale,iloc,intchk,Iostat,out2,L,isave
    integer numsub
    INTEGER Reason,subbasin_id,jsave,j,mc,mcc
    REAL r
    REAL,SAVE,DIMENSION(:),POINTER :: param
    INTEGER,SAVE,DIMENSION(:),POINTER :: subbasin
    REAL,SAVE,DIMENSION(:),POINTER :: scale
    inscale = 9
    in = 10
    out2 = 12
    out = 11
    Iostat = 1
    scale = 0.0
    open(inscale,file='scale_ssr2gw_rate.dat')
    open(in,file='ssr2gw_rate.param')
    open(out2,file='ssr2gw_rate_scaled.param')
    open(out,file='scale.out')
! Read user input for scaling factor and subbains ID
    read(inscale,*)numsub
    allocate(scale(numsub))  ! one for each subbasin
    do i = 1, numsub
    read(inscale,*)scale(i)   !ssr2gw_rate scaling factor for each subbasin
    end do
! find parameter(s) of interest for scaling
     i = 0
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,out,IN)
        select case (LINE(ISTART:ISTOP))
        case('HRU_SUBBASIN')
            read(in,*) line
            read(in,*) line
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value
            write(out,*)'found HRU_SUBBASIN'
            exit
        case default
            if( Iostat < 0 ) then
              write(11,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
     end do
     jsave = numvals
! allocate array to hold subbasin id
        allocate (subbasin(numvals))
        
!  read subbasin_id
        do i = 1, numvals
          read(in, *)subbasin(i)
        end do
    rewind(in)
     i=0
     DO
        i = i + 1  !save i for below
        read(in,*,IOSTAT=Iostat) line
        LLOC=1
        CALL URWORD(LINE,LLOC,ISTART,ISTOP,1,I,R,out,IN)
        select case (LINE(ISTART:ISTOP))
        case('SSR2GW_RATE')
            read(in,*) line
            read(in,*) line
            read(in,*) numvals
            read(in,*) line         !next value to read will be first parameter value         
            write(out,*)'found SSR2GW_RATE'
            exit
        case default
            if( Iostat < 0 ) then
              write(out,*)'end of file reached without finding parameter to scale'
              exit
            end if
        end select
     end do
     isave = i - 1  !reset to before parameter name
!
! allocate array to hold parameter
        allocate (param(numvals))   
!
!       read current parameter values
        j=0
        mc=1
        do i = 1, numvals
          mcc = subbasin(i)
          read(in, *)param(i)
          if ( mcc>0 ) param(i) = scale(mcc)*param(i)
        end do
! 
!  start back at top of file
        rewind(in)
!  set location in parameter file before header
        iloc = isave
        do i = 1, iloc
            READ(IN,'(A)') LINE
            WRITE(out2,'(A)') TRIM(adjustl(line))
        end do
        do i = 1, 6 !write header lines
            READ(IN,'(A)') LINE
            WRITE(out2,'(A)') TRIM(adjustl(line))
        end do
! update new scaled values in parameter file
        do i = 1, numvals
          ! Advance file pointer
          write(line2,*)param(i)
          write(out2,*)TRIM(adjustl(line2))
        end do
        
! finish transfering lines     
        !do
        !  READ(IN,'(A)',IOSTAT=Reason)  line
        !  IF (Reason > 0)  THEN
        !     exit
        !  ELSE IF (Reason < 0) THEN
        !     exit
        !  ELSE
        !    write(out2,*) TRIM(adjustl(line))
        !  END IF
        !END DO
        
        close(IN)
        close(out)
        close(out2)
   
    end program scale_params

