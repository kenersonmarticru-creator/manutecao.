-- =============================================================
-- EXECUTE ESTE SQL NO SUPABASE SQL EDITOR
-- Menu: SQL Editor > New Query > colar > Run
-- =============================================================

-- 1. Criar bucket de assinaturas (público para getPublicUrl funcionar)
INSERT INTO storage.buckets (id, name, public)
VALUES ('assinaturas', 'assinaturas', true)
ON CONFLICT (id) DO UPDATE SET public = true;

-- 2. Policy: qualquer usuário autenticado pode fazer upload
CREATE POLICY "Autenticados podem fazer upload de assinaturas"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (bucket_id = 'assinaturas');

-- 3. Policy: qualquer um pode ler (necessário para getPublicUrl)
CREATE POLICY "Leitura pública de assinaturas"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'assinaturas');

-- 4. Policy: usuário autenticado pode atualizar seus próprios arquivos
CREATE POLICY "Autenticados podem atualizar assinaturas"
ON storage.objects
FOR UPDATE
TO authenticated
USING (bucket_id = 'assinaturas');

-- 5. Policy: usuário autenticado pode deletar seus próprios arquivos
CREATE POLICY "Autenticados podem deletar assinaturas"
ON storage.objects
FOR DELETE
TO authenticated
USING (bucket_id = 'assinaturas');
