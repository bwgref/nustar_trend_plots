;; base = getenv('L1SCRIPTS')
;; !path = expand_path('+'+base+'/idl/startup/')+':'+$
;;         expand_path('+/usr/local/rsi/lib/')+':'+$
;;         !path

base = getenv('HOME')

!path = expand_path('+'+base+'/lif2/git/nustar-idl/')+':'+ $
                    !path

!quiet = 1
