function matrix = clean( matrix, tolerance )
m_real = real(matrix);
m_imag = imag(matrix);
m_real( abs(m_real) < tolerance ) = 0;
m_imag( abs(m_imag) < tolerance ) = 0;
matrix = m_real + 1i*m_imag;