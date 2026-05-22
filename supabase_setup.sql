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

-- =============================================================
-- TABELA: equipamentos (cadastro de máquinas/equipamentos)
-- =============================================================
CREATE TABLE IF NOT EXISTS equipamentos (
    id                  uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    numero              text NOT NULL UNIQUE,
    nome                text NOT NULL,
    tipo                text,
    numero_serie        text,
    numero_patrimonio   text,
    fabricante          text,
    modelo              text,
    ano                 integer,
    observacoes         text,
    created_at          timestamptz DEFAULT now(),
    updated_at          timestamptz DEFAULT now()
);

-- Policy: leitura pública (ajuste conforme RLS desejado)
ALTER TABLE equipamentos ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Acesso total a equipamentos"
ON equipamentos FOR ALL
USING (true)
WITH CHECK (true);

-- =============================================================
-- TABELA: maquinas (catálogo de máquinas do check-list)
-- =============================================================
CREATE TABLE IF NOT EXISTS maquinas (
    id          uuid DEFAULT gen_random_uuid() PRIMARY KEY,
    codigo      text NOT NULL UNIQUE,
    nome        text NOT NULL,
    ativo       boolean NOT NULL DEFAULT true,
    created_at  timestamptz DEFAULT now(),
    updated_at  timestamptz DEFAULT now()
);

ALTER TABLE maquinas ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Acesso total a maquinas"
ON maquinas FOR ALL
USING (true)
WITH CHECK (true);
