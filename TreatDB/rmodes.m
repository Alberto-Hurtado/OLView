function [modes,omeg]=rmodes(stiffness_N_m,m_kg)
%RMODES
%        [modes,omeg]=rmodes(stiffness_N_m,m_kg)
%        Real modes normalised to unit mass and  
%        corresponding frequencies in rad/s sorted in ascending order.
%         Ask also help on        cmodes eig fe_eig stimat
%
%  30/6/97   J. Molina

  [modes,omeg2]=eig(stiffness_N_m,m_kg);
  [omeg,ind]=sort(sqrt(abs(diag(omeg2))));
  modes=real(modes(:,ind));
%  modes=modes*diag(1./(max(abs(modes))));
  modes=modes*diag(1./sqrt(diag(modes'*m_kg*modes)));
