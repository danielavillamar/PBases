PGDMP                         x            proyecto2.1    12.2    12.2 O    �           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                      false            �           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                      false            �           0    0 
   SEARCHPATH 
   SEARCHPATH     8   SELECT pg_catalog.set_config('search_path', '', false);
                      false            �           1262    17340    proyecto2.1    DATABASE     �   CREATE DATABASE "proyecto2.1" WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'English_United States.1252' LC_CTYPE = 'English_United States.1252';
    DROP DATABASE "proyecto2.1";
                postgres    false            �            1255    17341    bitacora_delete()    FUNCTION       CREATE FUNCTION public.bitacora_delete() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    INSERT INTO bitacora(date, modified_table,time, usuario, tipo, modified_field)
    VALUES(current_date, TG_TABLE_NAME,current_time, OLD.modified_by, TG_OP, NULL);
	RETURN NEW;
END;
$$;
 (   DROP FUNCTION public.bitacora_delete();
       public          postgres    false            �            1255    17342    bitacora_insertupdate()    FUNCTION     /  CREATE FUNCTION public.bitacora_insertupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
begin
    INSERT INTO bitacora(date, modified_table,time, usuario, tipo, modified_field)
    VALUES(current_date, TG_TABLE_NAME,current_time, NEW.modified_by, TG_OP, NEW.modified_field);
	RETURN NEW;
END;
$$;
 .   DROP FUNCTION public.bitacora_insertupdate();
       public          postgres    false            �            1259    17343    album    TABLE     �   CREATE TABLE public.album (
    albumid text NOT NULL,
    title character varying(160) NOT NULL,
    artistid text NOT NULL,
    modified_by character varying,
    modified_field character varying
);
    DROP TABLE public.album;
       public         heap    postgres    false            �            1259    17349 
   albumprice    VIEW     �   CREATE VIEW public.albumprice AS
SELECT
    NULL::text AS albumid,
    NULL::character varying(160) AS name,
    NULL::numeric AS albumprice,
    NULL::bigint AS tracks;
    DROP VIEW public.albumprice;
       public          postgres    false            �            1259    17353    track    TABLE     �  CREATE TABLE public.track (
    trackid text NOT NULL,
    name character varying(200) NOT NULL,
    albumid text,
    mediatypeid integer,
    genreid integer,
    composer character varying(220),
    milliseconds integer,
    bytes integer,
    unitprice numeric(10,2) NOT NULL,
    employeeid character varying(60),
    inactive integer,
    reproductions integer,
    addeddate date,
    modified_by character varying,
    modified_field character varying,
    url character varying
);
    DROP TABLE public.track;
       public         heap    postgres    false            �            1259    17359 
   albumsongs    VIEW     �   CREATE VIEW public.albumsongs AS
 SELECT album.albumid,
    album.title,
    track.composer,
    track.trackid,
    track.name,
    track.unitprice
   FROM (public.album
     JOIN public.track ON ((track.albumid = album.albumid)));
    DROP VIEW public.albumsongs;
       public          postgres    false    204    202    204    204    202    204    204            �            1259    17363    artist    TABLE     �   CREATE TABLE public.artist (
    artistid text NOT NULL,
    name character varying(120),
    modified_by character varying,
    modified_field character varying
);
    DROP TABLE public.artist;
       public         heap    postgres    false            �            1259    17369 
   artistsong    VIEW     �   CREATE VIEW public.artistsong AS
 SELECT DISTINCT artist.name,
    track.trackid
   FROM public.artist,
    public.album,
    public.track
  WHERE ((track.albumid = album.albumid) AND (album.artistid = artist.artistid));
    DROP VIEW public.artistsong;
       public          postgres    false    202    204    204    206    202    206            �            1259    17373    bitacora    TABLE     �   CREATE TABLE public.bitacora (
    date date NOT NULL,
    "time" time without time zone NOT NULL,
    usuario character varying,
    tipo text,
    modified_field character varying,
    modified_table name
);
    DROP TABLE public.bitacora;
       public         heap    postgres    false            �            1259    17379    customer    TABLE     $  CREATE TABLE public.customer (
    firstname character varying(40) NOT NULL,
    lastname character varying(20) NOT NULL,
    company character varying(80),
    address character varying(70),
    city character varying(40),
    state character varying(40),
    country character varying(40),
    postalcode character varying(10),
    phone character varying(24),
    fax character varying(24),
    email character varying(60) NOT NULL,
    supportrepid integer,
    password text,
    plan character varying(16),
    ccnumber text,
    cvv text
);
    DROP TABLE public.customer;
       public         heap    postgres    false            �            1259    17385    genre    TABLE     ]   CREATE TABLE public.genre (
    genreid integer NOT NULL,
    name character varying(120)
);
    DROP TABLE public.genre;
       public         heap    postgres    false            �            1259    17388    invoice    TABLE     t  CREATE TABLE public.invoice (
    invoiceid text NOT NULL,
    invoicedate timestamp without time zone,
    billingaddress character varying(70),
    billingcity character varying(40),
    billingstate character varying(40),
    billingcountry character varying(40),
    billingpostalcode character varying(10),
    total numeric(10,2),
    email character varying(60)
);
    DROP TABLE public.invoice;
       public         heap    postgres    false            �            1259    17391    invoiceline    TABLE     �   CREATE TABLE public.invoiceline (
    invoicelineid text NOT NULL,
    invoiceid text NOT NULL,
    trackid text NOT NULL,
    unitprice numeric(10,2) NOT NULL,
    quantity integer NOT NULL
);
    DROP TABLE public.invoiceline;
       public         heap    postgres    false            �            1259    17559    dailygenresales    VIEW     �  CREATE VIEW public.dailygenresales AS
 SELECT genre.name AS genre,
    invoice.invoicedate AS date,
    sum(invoice.total) AS total
   FROM public.invoice,
    public.invoiceline,
    public.track,
    public.genre
  WHERE ((invoiceline.invoiceid = invoice.invoiceid) AND (invoiceline.trackid = track.trackid) AND (track.genreid = genre.genreid))
  GROUP BY genre.name, invoice.invoicedate
  ORDER BY invoice.invoicedate DESC;
 "   DROP VIEW public.dailygenresales;
       public          postgres    false    212    212    211    211    211    210    210    204    204            �            1259    17401 
   dailysales    VIEW     ,  CREATE VIEW public.dailysales AS
 SELECT t1.invoicedate AS date,
    sum(t1.total) AS total
   FROM (public.invoice t1
     JOIN ( SELECT DISTINCT invoice.invoicedate
           FROM public.invoice) t2 ON ((t2.invoicedate = t1.invoicedate)))
  GROUP BY t1.invoicedate
  ORDER BY t1.invoicedate DESC;
    DROP VIEW public.dailysales;
       public          postgres    false    211    211            �            1259    17405    employee    TABLE     3  CREATE TABLE public.employee (
    lastname character varying(20) NOT NULL,
    firstname character varying(20) NOT NULL,
    title character varying(30),
    reportsto integer,
    birthdate timestamp without time zone,
    hiredate timestamp without time zone,
    address character varying(70),
    city character varying(40),
    state character varying(40),
    country character varying(40),
    postalcode character varying(10),
    phone character varying(24),
    fax character varying(24),
    email character varying(60) NOT NULL,
    password text
);
    DROP TABLE public.employee;
       public         heap    postgres    false            �            1259    17563    genreperuser    VIEW     �  CREATE VIEW public.genreperuser AS
 SELECT invoice.email,
    t.genreid
   FROM public.invoice,
    ( SELECT track.genreid,
            invoiceline.invoiceid
           FROM (public.invoiceline
             JOIN public.track ON ((invoiceline.trackid = track.trackid)))) t
  WHERE (t.invoiceid = invoice.invoiceid)
  GROUP BY invoice.email, t.genreid, invoice.invoicedate
  ORDER BY invoice.invoicedate DESC;
    DROP VIEW public.genreperuser;
       public          postgres    false    212    204    211    204    212    211    211            �            1259    17416 	   mediatype    TABLE     e   CREATE TABLE public.mediatype (
    mediatypeid integer NOT NULL,
    name character varying(120)
);
    DROP TABLE public.mediatype;
       public         heap    postgres    false            �            1259    17419    playlist    TABLE     �   CREATE TABLE public.playlist (
    playlistid integer NOT NULL,
    name character varying(120),
    modified_by character varying,
    modified_field character varying
);
    DROP TABLE public.playlist;
       public         heap    postgres    false            �            1259    17425 
    playlistid integer NOT NULL,
    trackid text NOT NULL
);
 !   DROP TABLE public.playlisttrack;
       public         heap    postgres    false            �            1259    17522 
    trackid text,
    userid text
);
 !   DROP TABLE public.reproductions;
       public         heap    postgres    false            �          0    17343    album 
   TABLE DATA           V   COPY public.album (albumid, title, artistid, modified_by, modified_field) FROM stdin;
    public          postgres    false    202   5i       �          0    17363    artist 
   TABLE DATA           M   COPY public.artist (artistid, name, modified_by, modified_field) FROM stdin;
    public          postgres    false    206   �       �          0    17373    bitacora 
   TABLE DATA           _   COPY public.bitacora (date, "time", usuario, tipo, modified_field, modified_table) FROM stdin;
    public          postgres    false    208   ��       �          0    17379    customer 
   TABLE DATA           �   COPY public.customer (firstname, lastname, company, address, city, state, country, postalcode, phone, fax, email, supportrepid, password, plan, ccnumber, cvv) FROM stdin;
    public          postgres    false    209   [�       �          0    17405    employee 
   TABLE DATA           �   COPY public.employee (lastname, firstname, title, reportsto, birthdate, hiredate, address, city, state, country, postalcode, phone, fax, email, password) FROM stdin;
    public          postgres    false    214   L�       �          0    17385    genre 
   TABLE DATA           .   COPY public.genre (genreid, name) FROM stdin;
    public          postgres    false    210   c�       �          0    17388    invoice 
   TABLE DATA           �   COPY public.invoice (invoiceid, invoicedate, billingaddress, billingcity, billingstate, billingcountry, billingpostalcode, total, email) FROM stdin;
    public          postgres    false    211   q�       �          0    17391    invoiceline 
   TABLE DATA           ]   COPY public.invoiceline (invoicelineid, invoiceid, trackid, unitprice, quantity) FROM stdin;
    public          postgres    false    212   ��       �          0    17416 	   mediatype 
   TABLE DATA           6   COPY public.mediatype (mediatypeid, name) FROM stdin;
    public          postgres    false    215   �       �          0    17419    playlist 
   TABLE DATA           Q   COPY public.playlist (playlistid, name, modified_by, modified_field) FROM stdin;
    public          postgres    false    216   "      �          0    17425 
   TABLE DATA           <   COPY public.playlisttrack (playlistid, trackid) FROM stdin;
    public          postgres    false    217         �          0    17522 
   TABLE DATA           8   COPY public.reproductions (trackid, userid) FROM stdin;
    public          postgres    false    218   0R      �          0    17353    track 
   TABLE DATA           �   COPY public.track (trackid, name, albumid, mediatypeid, genreid, composer, milliseconds, bytes, unitprice, employeeid, inactive, reproductions, addeddate, modified_by, modified_field, url) FROM stdin;
    public          postgres    false    204   �R      �
           2606    17432    album album_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.album
    ADD CONSTRAINT album_pkey PRIMARY KEY (albumid);
 :   ALTER TABLE ONLY public.album DROP CONSTRAINT album_pkey;
       public            postgres    false    202            �
           2606    17434    artist pk_artist 
   CONSTRAINT     T   ALTER TABLE ONLY public.artist
    ADD CONSTRAINT pk_artist PRIMARY KEY (artistid);
 :   ALTER TABLE ONLY public.artist DROP CONSTRAINT pk_artist;
       public            postgres    false    206            �
           2606    17436    customer pk_customer 
   CONSTRAINT     U   ALTER TABLE ONLY public.customer
    ADD CONSTRAINT pk_customer PRIMARY KEY (email);
 >   ALTER TABLE ONLY public.customer DROP CONSTRAINT pk_customer;
       public            postgres    false    209            �
           2606    17438    employee pk_employee 
   CONSTRAINT     U   ALTER TABLE ONLY public.employee
    ADD CONSTRAINT pk_employee PRIMARY KEY (email);
 >   ALTER TABLE ONLY public.employee DROP CONSTRAINT pk_employee;
       public            postgres    false    214            �
           2606    17440    genre pk_genre 
   CONSTRAINT     Q   ALTER TABLE ONLY public.genre
    ADD CONSTRAINT pk_genre PRIMARY KEY (genreid);
 8   ALTER TABLE ONLY public.genre DROP CONSTRAINT pk_genre;
       public            postgres    false    210            �
           2606    17532    invoice pk_invoice 
   CONSTRAINT     W   ALTER TABLE ONLY public.invoice
    ADD CONSTRAINT pk_invoice PRIMARY KEY (invoiceid);
 <   ALTER TABLE ONLY public.invoice DROP CONSTRAINT pk_invoice;
       public            postgres    false    211            �
           2606    17569    invoiceline pk_invoiceline 
   CONSTRAINT     c   ALTER TABLE ONLY public.invoiceline
    ADD CONSTRAINT pk_invoiceline PRIMARY KEY (invoicelineid);
 D   ALTER TABLE ONLY public.invoiceline DROP CONSTRAINT pk_invoiceline;
       public            postgres    false    212            �
           2606    17446    mediatype pk_mediatype 
   CONSTRAINT     ]   ALTER TABLE ONLY public.mediatype
    ADD CONSTRAINT pk_mediatype PRIMARY KEY (mediatypeid);
 @   ALTER TABLE ONLY public.mediatype DROP CONSTRAINT pk_mediatype;
       public            postgres    false    215            �
           2606    17448    playlist pk_playlist 
   CONSTRAINT     Z   ALTER TABLE ONLY public.playlist
    ADD CONSTRAINT pk_playlist PRIMARY KEY (playlistid);
 >   ALTER TABLE ONLY public.playlist DROP CONSTRAINT pk_playlist;
       public            postgres    false    216            �
           2606    17450    playlisttrack pk_playlisttrack 
   CONSTRAINT     m   ALTER TABLE ONLY public.playlisttrack
    ADD CONSTRAINT pk_playlisttrack PRIMARY KEY (playlistid, trackid);
 H   ALTER TABLE ONLY public.playlisttrack DROP CONSTRAINT pk_playlisttrack;
       public            postgres    false    217    217            �
           2606    17452    track track_pkey 
   CONSTRAINT     S   ALTER TABLE ONLY public.track
    ADD CONSTRAINT track_pkey PRIMARY KEY (trackid);
 :   ALTER TABLE ONLY public.track DROP CONSTRAINT track_pkey;
       public            postgres    false    204            �
           1259    17453    ifk_albumartistid    INDEX     G   CREATE INDEX ifk_albumartistid ON public.album USING btree (artistid);
 %   DROP INDEX public.ifk_albumartistid;
       public            postgres    false    202            �
           1259    17454    ifk_customersupportrepid    INDEX     U   CREATE INDEX ifk_customersupportrepid ON public.customer USING btree (supportrepid);
 ,   DROP INDEX public.ifk_customersupportrepid;
       public            postgres    false    209            �
           1259    17455    ifk_employeereportsto    INDEX     O   CREATE INDEX ifk_employeereportsto ON public.employee USING btree (reportsto);
 )   DROP INDEX public.ifk_employeereportsto;
       public            postgres    false    214            �
           1259    17544    ifk_invoicelineinvoiceid    INDEX     U   CREATE INDEX ifk_invoicelineinvoiceid ON public.invoiceline USING btree (invoiceid);
 ,   DROP INDEX public.ifk_invoicelineinvoiceid;
       public            postgres    false    212            �
           1259    17457    ifk_invoicelinetrackid    INDEX     Q   CREATE INDEX ifk_invoicelinetrackid ON public.invoiceline USING btree (trackid);
 *   DROP INDEX public.ifk_invoicelinetrackid;
       public            postgres    false    212            �
           1259    17458    ifk_playlisttracktrackid    INDEX     U   CREATE INDEX ifk_playlisttracktrackid ON public.playlisttrack USING btree (trackid);
 ,   DROP INDEX public.ifk_playlisttracktrackid;
       public            postgres    false    217            �
           1259    17459    ifk_trackalbumid    INDEX     E   CREATE INDEX ifk_trackalbumid ON public.track USING btree (albumid);
 $   DROP INDEX public.ifk_trackalbumid;
       public            postgres    false    204            �
           1259    17460    ifk_trackgenreid    INDEX     E   CREATE INDEX ifk_trackgenreid ON public.track USING btree (genreid);
 $   DROP INDEX public.ifk_trackgenreid;
       public            postgres    false    204            �
           1259    17461    ifk_trackmediatypeid    INDEX     M   CREATE INDEX ifk_trackmediatypeid ON public.track USING btree (mediatypeid);
 (   DROP INDEX public.ifk_trackmediatypeid;
       public            postgres    false    204            �           2618    17352    albumprice _RETURN    RULE       CREATE OR REPLACE VIEW public.albumprice AS
 SELECT album.albumid,
    album.title AS name,
    sum(track.unitprice) AS albumprice,
    count(track.trackid) AS tracks
   FROM (public.album
     JOIN public.track ON ((track.albumid = album.albumid)))
  GROUP BY album.albumid;
 �   CREATE OR REPLACE VIEW public.albumprice AS
SELECT
    NULL::text AS albumid,
    NULL::character varying(160) AS name,
    NULL::numeric AS albumprice,
    NULL::bigint AS tracks;
       public          postgres    false    204    2771    204    204    202    202    203            �
           2620    17462    album delete_bitacora    TRIGGER     t   CREATE TRIGGER delete_bitacora AFTER DELETE ON public.album FOR EACH ROW EXECUTE FUNCTION public.bitacora_delete();
 .   DROP TRIGGER delete_bitacora ON public.album;
       public          postgres    false    202    221            �
           2620    17463    artist delete_bitacora    TRIGGER     u   CREATE TRIGGER delete_bitacora AFTER DELETE ON public.artist FOR EACH ROW EXECUTE FUNCTION public.bitacora_delete();
 /   DROP TRIGGER delete_bitacora ON public.artist;
       public          postgres    false    206    221                       2620    17464    playlist delete_bitacora    TRIGGER     w   CREATE TRIGGER delete_bitacora AFTER DELETE ON public.playlist FOR EACH ROW EXECUTE FUNCTION public.bitacora_delete();
 1   DROP TRIGGER delete_bitacora ON public.playlist;
       public          postgres    false    216    221            �
           2620    17465    track delete_bitacora    TRIGGER     t   CREATE TRIGGER delete_bitacora AFTER DELETE ON public.track FOR EACH ROW EXECUTE FUNCTION public.bitacora_delete();
 .   DROP TRIGGER delete_bitacora ON public.track;
       public          postgres    false    204    221            �
           2620    17466    album insert_bitacora    TRIGGER     z   CREATE TRIGGER insert_bitacora AFTER INSERT ON public.album FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 .   DROP TRIGGER insert_bitacora ON public.album;
       public          postgres    false    202    222                        2620    17467    artist insert_bitacora    TRIGGER     �   CREATE TRIGGER insert_bitacora AFTER INSERT ON public.artist FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate('insert');
 /   DROP TRIGGER insert_bitacora ON public.artist;
       public          postgres    false    222    206                       2620    17468    playlist insert_bitacora    TRIGGER     }   CREATE TRIGGER insert_bitacora AFTER INSERT ON public.playlist FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 1   DROP TRIGGER insert_bitacora ON public.playlist;
       public          postgres    false    222    216            �
           2620    17469    track insert_bitacora    TRIGGER     z   CREATE TRIGGER insert_bitacora AFTER INSERT ON public.track FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 .   DROP TRIGGER insert_bitacora ON public.track;
       public          postgres    false    222    204            �
           2620    17470    album update_bitacora    TRIGGER     z   CREATE TRIGGER update_bitacora AFTER UPDATE ON public.album FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 .   DROP TRIGGER update_bitacora ON public.album;
       public          postgres    false    222    202                       2620    17471    artist update_bitacora    TRIGGER     �   CREATE TRIGGER update_bitacora AFTER UPDATE ON public.artist FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate('update');
 /   DROP TRIGGER update_bitacora ON public.artist;
       public          postgres    false    206    222                       2620    17472    playlist update_bitacora    TRIGGER     }   CREATE TRIGGER update_bitacora AFTER UPDATE ON public.playlist FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 1   DROP TRIGGER update_bitacora ON public.playlist;
       public          postgres    false    216    222            �
           2620    17473    track update_bitacora    TRIGGER     z   CREATE TRIGGER update_bitacora AFTER UPDATE ON public.track FOR EACH ROW EXECUTE FUNCTION public.bitacora_insertupdate();
 .   DROP TRIGGER update_bitacora ON public.track;
       public          postgres    false    204    222            �
           2606    17474    album album_artistid_fkey 
    ADD CONSTRAINT album_artistid_fkey FOREIGN KEY (artistid) REFERENCES public.artist(artistid) ON DELETE CASCADE;
 C   ALTER TABLE ONLY public.album DROP CONSTRAINT album_artistid_fkey;
       public          postgres    false    202    206    2779            �
           2606    17479    invoice invoice_email_fkey 
    ADD CONSTRAINT invoice_email_fkey FOREIGN KEY (email) REFERENCES public.customer(email);
 D   ALTER TABLE ONLY public.invoice DROP CONSTRAINT invoice_email_fkey;
       public          postgres    false    211    209    2782            �
           2606    17554 &   invoiceline invoiceline_invoiceid_fkey 
    ADD CONSTRAINT invoiceline_invoiceid_fkey FOREIGN KEY (invoiceid) REFERENCES public.invoice(invoiceid);
 P   ALTER TABLE ONLY public.invoiceline DROP CONSTRAINT invoiceline_invoiceid_fkey;
       public          postgres    false    2786    212    211            �
           2606    17489 +   playlisttrack playlisttrack_playlistid_fkey 
    ADD CONSTRAINT playlisttrack_playlistid_fkey FOREIGN KEY (playlistid) REFERENCES public.playlist(playlistid);
 U   ALTER TABLE ONLY public.playlisttrack DROP CONSTRAINT playlisttrack_playlistid_fkey;
       public          postgres    false    217    216    2797            �
           2606    17494    track track_albumid_fkey 
    ADD CONSTRAINT track_albumid_fkey FOREIGN KEY (albumid) REFERENCES public.album(albumid) ON DELETE CASCADE;
 B   ALTER TABLE ONLY public.track DROP CONSTRAINT track_albumid_fkey;
       public          postgres    false    202    2771    204            �
           2606    17499    track track_employeeid_fkey 
    ADD CONSTRAINT track_employeeid_fkey FOREIGN KEY (employeeid) REFERENCES public.employee(email);
 E   ALTER TABLE ONLY public.track DROP CONSTRAINT track_employeeid_fkey;
       public          postgres    false    2793    204    214            �
           2606    17504    track track_genreid_fkey 
    ADD CONSTRAINT track_genreid_fkey FOREIGN KEY (genreid) REFERENCES public.genre(genreid);
 B   ALTER TABLE ONLY public.track DROP CONSTRAINT track_genreid_fkey;
       public          postgres    false    2784    204    210            �
           2606    17509    track track_mediatypeid_fkey 
    ADD CONSTRAINT track_mediatypeid_fkey FOREIGN KEY (mediatypeid) REFERENCES public.mediatype(mediatypeid);
 F   ALTER TABLE ONLY public.track DROP CONSTRAINT track_mediatypeid_fkey;
       public          postgres    false    2795    215    204            �      x��[�r�8v]���tUE�I�����ԻJ�l�Z���^ Id&FL"��R+G̗8fᘅ#a{��O�%>L�����]]q	�y�*`g&��kS(>Y�����ߙ��?*>�iU*���X��t���l*Ӵ���Z�G���~,dw�(SU\f	�i��"v�0�Z�O�����Ϧz�o3U�p�h�>��J%�J����4����L�*�˒���F�Q�ʹ��If
6���,���_�Kձ��?3UΏU�Bp�zlR%��|Vl�<
�������>1�A?O"d�~����/7�P�27�^�<�a����ɯ�FҌ��ю
lTc8��g��x�V<�]q����~��$N0��[��w|R�
o.���:SA�l2zY�U*so$bs���'��ß.�,�Y�X����,m��C")���!{�UZa�K~��[�'�
��)l��GT�|b����n'F̚*Y/�	6j|N�u���	�i�@�S+x��/E�8�P�mc!R�q*�%*��	���l�Vq���}���)���<1D��R~R��x�>��	�M��n�_��R�z�<�:e�)����ju;4���/p�h_n���m�S&��ΩGM���*"|@)�����ueRz�܇~����B��l|�������U9T�;���rVeOl�D=$&
|��������W��
Q *�p�;�U2+%?GRT�Aix��=U����+��*?8���������{�΢ĳ�{T�Q9jG�/�J˶��T�[��XB�'PF^��i�D�)�P�A.Ӵ"��/�q�q_ 0�(#��j�iE|��o�8�_�(���&T��o�cH���1@�� �?�$��Jԑ:Ou��3�C'2j��9KӉ��$F�HG�C��x|��}��P���%�g�A��`<-����>�1|��>[�.�dGQ�	
� g�q;0$�ʲ#6v��~J˨��Z'�E���ڢ����䫯0�K&8����م�
*/L���C[=�Ҫ��
�&������A���� ,���7��Fo;��_E���%�
��Q�m�"P�b�"ZN41Y�T0ʭ�D�Me^�kKԧ�Z.r��(�d>�}��H����Kl��!�|�Q�m�v��`��'Fi����W��4 ��%qq
_�d#c������{@���#v��E6�?��G�Z�h;%`)�S�Ȕ�\�_��ze9~��,@��m�M4��65�����wBk��mR\, R���I��}%��	1�L�L򛚎ψn�����o�Lm�) ��l]�"Nox�tx-�	��,�Y���@�`�$!xT�	T]�3�K��]ϻ����Ú�\��-�+:�;�\ͧ����è`7��݁���{N��#��'W��5JZi�@�.@P.�s�� �d�A!2|��z��27Ŗ���5����e�5�]* Ƙ�ɨ�	Vew�ϑ�wm�
o9)��R�D�e��]g�������Y�[g<`��N�;��r����N�(ڔBwl��tg@[P&�[$У�9�Ee#� .,i������j�c4O�I9|'l������+=wmd����O��K6�s��Y�$]9�����u�ҡ7&�cA�(��Ԫ�5���B�tN>C���Y���C#b;<���������x��o!:��~�_��K���������L�u�ê"gDdz>3��QH\GE �\��~��{�'�S��	��j���`����,�Bi팍ٽĳ�~��N0r�m�og(��ؾ�m��5򷯷G q�K�k�T�oz�p���+r�+�%�Q{L��v�jCj�Egd���N��Q�屬mN���=(Z�i5/
e<bY��x��B����4�/'�mp���#
���<S_ļ�a���{�� dr����Yp�f���>����4J�ǅ��pq�z�(R�C6l_��wm������ӆ\|�O5nA�b���;����7"�#|M$��p˃SZ���kq��q!��:�j#�?W���A��}*A�(+�g�o�!;�d�}ǻ�b�r��z��i���8lYu���o�|jN�N�-	�.�!z�[��k����7'�^������[j�`��bTwH`�˂Q��1B#цN:u �H$��*�!�[U���=j�Gci�}{��\�\�6dnX[KAq���5�0n�[n�����[�y���*-[�ל��r�����Ⱦ���T�"�q;K��>S����S�P�
�\����5%��9"Ƅ�XԐ���6ň8;x'��#���g���K���f�6"��ǈ4j��� �  �s7+���1�!��T&��t����I�jg�V��2�]��_��	W295�h/J��=ʕݣS	�E,Y"Ƅ���T9�#~�@.Ԧƪ0ƌؤ�o�9��Lvw��~2������*cb��z��Z{�wE|�^Nh�N��9����fU�~���%ӊ�O����i��	G�(߅I�=��� R��C
,�AV+]�J�����B[=8c��ns��ث��Z������&Xb��fPV���2G��Ibil�z'��C���iO��%���*��-ѤF�@�agw��<6۔f�ׁ
��q��)t�[~V!�Q�	��P���q�İƓYj���y=�Fl���3ؓ|�j�p�.���8G5B4g�
i���B�j��V#f���I�A`��	GÞm��iMY,ޗ��"$o�jX��>�ȅ AG�+%�i�:	/"�+@����#�o�n�5�$]��6�p�0��[(�k��U4.�T���:��;��*��H�	��4'�9R"͟�+	�:;6��-וPf��{��`�#��z�(P_4�fM�I��BA�Dn0
?CY�������h����A�\DW��/�=b��Q<�A�9�%j�b��"8_��|j�J��cz~��9��xΉ`R��O0��]HGn��UE=ʴ|�Dxh9}�j��%�FK�B���C�FJr�|��N��9#v��R]������C��BԔ��� P䓫ܙ,$��?�nM��؞1�h��+�a@�_��F���w�u1�݄��gP*�sx�5���"���Ɇ�gQ6��(�O�ڻ�Nn���w����͑]O%_�r��t�嵀��$m������6BHU����|KPV��P����S�
{�S�'����?H?:��C�yHQ��ЁcQA�y]/X't=�	ǟB����	�eo�YW�'� r�UH'�kI7� �)/o-ᰊ�?�;&�6���iL�[e#�
��ݳ8W�|�tG�BԞs{�G�O���BF���*o#C��vt@KX|�޹�OȿOK�!}������'TD2ٰ��evZ�4X��Y��Q�f� �޾ ̘k¯gL��O��C^k*�M��%eS5=���G:�(5*m�L�+@�UZ%���/y~��#z�|d�k��!%�g�=H�Wt�� �֠��m�j��u��o^
�C]�谯p���65�#v��zj_7���~��T#9���Gxq%3�7x�������Q;�x-	$�����?�{Y�<yw�Eŕ��m"�t��c�]��C�߬��uFi$^� 
k\\��'��!������1�UȏO�
��+��������a������L/��������-�%;a������r�S7lP�8х�M�׺4��8p������Zao�n�r��|��c�D�T���V�%{|A,NM��
�V�f����3c=�
%������������#��yM�k���#_���K�0��(�6ZY�P��\'���"k�cS�Bk�7WةSr��Ak��o�٤�R�Z�.�s������!A�Ґr��w�������n��x�3�� E�u�Z��-��)p�,{J`�_Z�o4p�5��8W�-��p˃o�C�oȩb�J������ѮP<�ŉ8�սZ�������-�T���gb��Z^�n���!�fb��x���^a�Mx�,��j�'����R�lAH�'.�L^/�O�$|2�D�n[��`,T�����DO_/��p���y�b̎���;UU_�%�ӃP�R���P;�FM�>�L.'%*,�q��H��$���8ԕ�Ǯ��8�ĵ�@�H���]�=7-;k
v�ي�,Yi*c��
	}�KL����Y��+�}�K��������FOF���:|��1�14`O~q&���=㋠�@��c���N5ڡ�l̆���⪮����H���D��p5�
�j�����
�=����j�� �P��Y �i��̒+Y�@"U�V��y5�k�Y,����;>z�*���q��lbW�0���IG�h�z���dⰭ� ����l(�T�]T��kCO�q ��|���H��Zcg�x����C�*VCq���6Gfe�k
ٴ}F�����@L�@@J�߹˗�xvMK�d�ws�!(�new�Q�vfRI��돉g:mIp��O 隷�XS12�R�i��=�533yl;��7����REϗ���d	�s��y��bx��Dn�C~�~��+���L�f�U����&ӡ-��v�2���m��U
R�
���Ts[�-���d��e�՞o��.ê��p�R��l�[�S��
>J/�բD��Um��Ѥ��A�@I�]���r��z	�9m�!mS���,�}'�n�� �/ ��p˗�� �RAۼV�jO��܁l+�	l�hT-4���_��:�:�OP��}���
� �`�����.t�t5>L�K�~U�U�@�H�rU�Ֆ\x�]�8�A��)��.��cwN�A���d_�m,~֬�g����L҂b�k�H'vO:F��*lW�f0��z�7#��n�G��.�ʷ����5z�����	�L<��F$��ip�J��LT5�\���hr�4��wE���4���B�Q��5�A�&(�a8��9�F[Q NAY�����F:���>�Ҟ|C�7��E����X6��p�ߣ�+�%d��ʫ�j��N p�ѝ�7�xz��� \6�ۛ�OL8���91������"�����m�1(����0U���w\I�oI<�<)�� �ƺ�����\���p~���#�A�=�^�ҡ�����\����:'NV�m� Hw%��Fl�PM��3AJ��
m�.��΍��s� Ʃg�-�nÏ�M�/w{�\���I}�F��*�ȌѢ�"�U�� V�4�� ��c�K9��'�
G}��q�5������?n�NK��Q�����j���"_��|$:�2E���(� �\�=�]�r��y��-xAD��G��RO�V�ta��:�r�!��Ei�Z��:��T�"��8!�o`�Oܚ��v�
�#�����Hoõ)�ӳ��?�����p0�8���ڮ���(b-��0y��j�R�wWл3>S�].?��iMF��+�
��[�;� �D�_^Rw�7G�;j��W�A�sC~�`�K����M�ɏ�j�M���q	���vH���s�,��;�'��eϻ�8ߟ�G�q���`�zٺ�xN��"�T��7�5�X��~P������{<�pk�r"BO�K�C�>��'��iX�
��v ���=��gA��#i �i�^Z�i�g'IP�m_b%�x�sӶ��0���g������{�@@�7�S��b�C���c����P���V ��‖/!赤�"v��t��-�(��L-��рϫǊ˗�kZ0&���l{�Z�mI�;�#��D�B�9�|�$�8�^9�দÜB�3�WZ��q�j'�x��/�#ª��%î<@8Qc����gv�2��*��u�S� �ũϾ2V�"�=�yp�~T�N>vY�՚��R�㕦K|�uwY�{PǏ ̽�"4��Y��u�_�	5�:o�������>��fj�~;c��AJ/����7 Ҹ;����!�
6TO7���~�����˩bz��|�q,yRkb�y��2���J	�Ww���}��ޟ>��7N�i��$��ȥ�"Y���{s������Zk��R���������?__:����ί���{�����yw��C�9%Ss��w7���>��M
�����xZ�L̍s	'��
�O~=�T������(K1��b��\T�k8.���ɲT�q�C�p_B��$Y��m����������������������������������������������������������������������������o�Y���9�Vޣ��܈U�;� ���o�y�`a�������W��?�~�������H#�4�H#�4�H#�S����ټ�t���K.�_?0�9}w��l��&��f��G��wnZ)�kձ?<~�BY�V�3��=�xjan�ʷk���}n�|um��65�j���ڌ|h�D�'�k��+��&F94�������\�;qu��XxW龱Ph
_�ð@�h&�j�^ܠ�K_!����
�)n����&=�W�
>��1�>}�m|�^�ysw^�%�=ʮ'^��y����bU���ҁ��	¶�%RT�j��8�tڭ�������V�����r�D[��RLN�������+��rƻ��6�>��:�����1��f���i�����?���ھ(��zu�j��9i�����������Wt���m�lw�oG=ڼJ�.�jUP�i�Z�*�j�b�>+o�?N�?.���jsb�6Kጬ(�O���+.4]u}����]�{9^���`�3	����a\��R?������H��>��Wz/GN�_���>���]m/d�Cb=�"> �?W��y�t����%�E�ޔ��|�2�	��ȏ��k}�d��e̻�-���h9򇸽|Wݿ����Vi��m/o��Ey�~ZJ�=�7B��n�V���!?�w/��Q��=B�/�ړ�z��0�>��e�BW�8�p�S�퓥j\�҇�l�;���i�]���|��y�{<]�!�9O�zQ��s���-��M1�O�}i��c,h��eck���a.�Q�9lXk����E\-��S?��E��;9�x1U��T8Й]vl�9��.�=ü��w�~�v���m��WbuW?;����ln�4�Q�̫��y��-��ߜ(�5��o6��>�1��W�3n�ൾ����~L��^��w���v�1�|��^�a�^�������O�,����a�ϴ���99mD���������]x�K���؋�ot���6�= :'+����~���`���b�w��u/��]���ʠ����B#���xU����]�����9��UE�� �׻~?ґ��d%y�]���B�`�����We��^N��nU?>�]�y��������m�^d��^F���u���p
�-j0.�`,X[]���v��O���y^�'���X��JL�?DQ�}H�@g�dK�2V��j�y;wV(�ҡ��{W�������=����
_��$Ϋ��zsÐGްgq;n�E�����~��nq�jD(o�E���b���6��"ad}�ys����ˠׇ1o�I<J�x�Z��:��כ�P���Ԯ���)���J���g/o��}V�g��6,�D�Z�0Qd���ạ&��Ӳ�Y����{��c}���g����VOFp��9&ow�~m��H���eQ��v� o�G	@�B\�l:��7q�>��8m�z��t�p7O7e��MPy0'~S;.`��������=)n�縻�7G[�Gq����y�\�1�����޾�lyj+��j\�x�D�VM�ퟨE�M�^�v��e�����P�S��������.K�(��~�P?rٲ�0�>*9(�þ���a�<l7��0���#+>�Vq#����� B�!b�l�G��&
�OP��v��k�7O������~�޸l ��y�}S�ؕ�鸒U+r��b��^��+E���`"ukT|�_>N��N��`�
vcY�����>�F>����o��~.��ym���
�nrnlߛ>�0�&Y@Ӄ�$��*�U��}���%�>7��������A7P�%k�f�b�m2���ɗ����Oʳ���y	����� ��M��5Y�]�51�����p�Qm�b[L�*��w��n\�5���C�L��[p�\3��U)�B�ҧBOD����-��yŏ4}�ڡ���Ih��$����&4��z���f�G������~�n��!&������O��E�d�pTg���Zf�A<��a6:��oK�s���vP�ì��f�N�������y�K��F��w�lRN���Vj��mP�O����1 /'�Pp��8)K3�.u0Kr�^�����q�9�ٺ @�[���{ŕE*�zO3+j���ط���0߃5��oU���#��T}�u�)G��׹��@��FӤ!��V좢cz��g���� r�F
H�.��2�
t���M\n��+��b_�kˠ��Y��E�)��(��Q��q�}U6����B4�H�"ٴ8�m��T�C�^��� iQ�!��mF����૰���UU��3��-H�F�Jr�o�p	i&%��K�0����|�↑U�j�8�A�Bk{*�����w�P�{J���2��|d*�x�:�'?A��u&�َ�L�v���@���`�=��}k ${��r8��=z�a��ٔ� i@�@y�RϼZqc�>�P�*yl��"��;�Э�^�6(&֮mzQ]4!&X�1a���<Z�8% O.%��(��l�I�L!" FO�~1�2��� �`��A1�
�B}�f*ڇ���f���0/��,�X\C/�)�ђ�3^
.7�%s�\�C����#<K�ЀT<&%;��S�A������!�
g�	��tb3,���҆��:I;��m�9Pʴ���$(�a�a4?���H����� c��ku�BAl.^Ux�"�>�3�fEV/�"�gv�RgR&�A���S�(�%����u��0�}�R���K�h�����Rw��9��c��7 G��γ�ҁ
���υ�j�a�9y�Q$���3���2����A��u�J�3m�7$�C��d�U�4w�n�i��t=��x���ҰI1�$�ā��P�dYYH���#\1Z����&'�8�G��80�D�\dqܐV��!L�,���5	�%*ip��$�h����)����B��i<�H:q�_�ђ�1qq�%e�AQ�^����g1���ȍ����[�\s�����u(x=V�P=x3
?�0�}����+��W �m>�����98+�:�YK��cx5��}��&��Ġ�^�O�����Lc��Ȉ
��ݠ�(
�s' �n�\@�+�4'��]��U+�	��QgI �J�Cѝ0��V��1���^\��zlo+�3k�ң%v�g`�~�)]�@��ͨ�9W�1\'˂CKڵ�^�d[Y"U�	/�&E���G� YM������1!B����L�C�	,�3m��=\l�᷒i M�͡1��+�,�4b��~�� �R���܈q�Ǩf=��E�+'y	�RX�4O�0��\
�C
[��r���"x
� ��Bqhlc�R ��9:�M��@b�{��$��*�'�4��)����8Il�C/-��@�l�@eAe�LfSiS)+��
u�DG�h��1+P\���W8"����oudmiEKL�<N٩�����~��X��Uhː]�m�2$��+
�G*�-+�q:̈�A�z4�]��w��oU�����l.�f�9h{4{�V;�
X�b5R��� �$5D��p�^�d(L4 �0:bf��Z�.�͸�����(�h卸(S�+�ZeJB�@Y/V"s!O�̦h�� ��J~ �� �!��p���ɷxg���Gr����q)��-�2�G#?�M��º
���8�[�riًI�%�T-I���,����Ȓ����CWF�L++p���_XU�7(v��B�(�1^��FIeD�*z�9�x��*���j�8�M�H�g���6�^��G�IĲ�D'q8W�����j�Hlh�.\4��h��$�u�1Y0}�=�����;w��qY&      �     x����n�8�5�\�(��2�:i�3Il�u��@7yd�����t�~HM��<J�u-�� ������м	��;h �/\����%�V����L��ÇI1��R��r�D<��C�a�6}۠�9�HG�n�5fK�~���6�5�V6N�����o�M���6>��v�P����b���5�+Z���f��2ٲ�,B�a����K�z���c*{��-`��ט�&��	g52%}η�]��AW���6�x���G,q5�m2{�#nj�b��W.䏼JS��$�$��{�p1
�����.�>�r�na���ѢF
�Kw��l6��
�      �   �   x�M�;o�0�g�Wh�XG�����H��)ڥ!�E2,�E�뫶K7���wG	��T�H�;��đ,���G�L,f�4����ظV4�Z\@eG��c����#�5�|�rg?�6���ʇ@��O�R���MM���P�P3M7�@�̪,Hs	{�:�Mَ�f�x��mQ.�6��}�5�\Wpֆ"FG��5�����
��?r�R���B����J�l��۴��? U[K!${�����D�a^2      �      x����r�ƕ����h����UH�צ(��%{+U[ "a
�����Q��
�;��+�1W?��#����V嘞ko�"\ެ����X5u�(g4�h����e�bS��daM ɴ�
���l�q�6
dgM���u�)���U}�l��w�mN��g*�F�=r�i���D��D��UQ�o_6����w���d~N���Xf�]���\�F�k�Z�~��+�d����
ٻ�^_�'E��k������Gd~�6��a�������?�Ps�0Y�!)0
M�lH7=r�����c�0ǃ�9���s���x�X�EQ^m��T(��6����'�Y�����f�a�u��5�
[(���������*�z}ӚYr��J��&;6sJ�.����[s�͘��S�n��0A�N��_u�1�M5����b�V˾2�h��+Π1WPGs
��u�9��Y7��F �=iB'0�����< e����8�2�X�,xT�#J������7��u7��ۮ��Cmm��@�E�x[/���8�w���i�Q�+/^��r������EzyvQb�X����Fyyh�0l����4���l��Q]����[��V��d�-�&�&�]7�E���ߴ_�½��f�;i�뵹��Smﲾ;����*) +�%S�{@?m��~)����
� ����jHV�@�=����X�����mQW��b�5��ϻ���CߠzZ�����,�����n�wB�ÿ^�eO[��9��WP��S������*��I�@�;�*1��Ld#��}�i����׫ҚqҬ��~��<�=�;�Q�G� �fX�S`H�n��Y�݋˩D ;��+�nib���/r"�����h���_�9xR6�K��țR���Pڿ�on�fٴ���Y/�i�,��l7��b|�$��@ �)q>�����Si����z՗P�M��s��.��B}�bk�P��������!��$���##A؅�i����}_\}!D�{�g1����1:̤��;���w���BPs0�0A(B�Pu�5�j���o��x�eYl����|n�������1H�������0C�3{}�����H
8����&���v��!F�;��������4���kgm���	�ޏ�A,bM�`n���v�ċ� ���TäH�8����u�:$���9df��RQ�;P/�-�_���0`�C5�,�e;'m_���d���[3�wӟ���T]ϴ��n�Uio�P��G����m���(ى�e�UӖ���f2Bx��ϭ!@	rQH���I���o恎b�����$C�ꑖ��W���ـ�Mo
���W�u�EUx��ҰO��kya�pxY[�vJ%)s?�r䔶l��`�:$�J�}��K%RZW�{[��bק�zP���&SG&���eK�f~�9�� ���G�
!�C�/�=l�(D�{�x>J�
�U�~и2�cz�%4Xç�����4e���ؑg-u���F���4Sf��.�yh'�.K*� �0ȇ7]�X�������BJ����x��zF���-��E�~Y��5����xd�U6�#��(�&A��� �:�'^L�4�0��<���`�"(#6N�xXGi���c�6��G�5�(��A|B�5X�!G��\b��� �'%����e�Ѱ���<v, ���R�������t�_1�'��(AxR6ȗ�/RJ�K��2��U��x�SRP=�3=�A�x���)�ֱ!-����v$��AjJ�5�g/��	�7�[�M�����l��"��(,�t�Mh�l �5���qHM5��;�EG���䄆k�������+PJN^%�����Z����B�s�($����]�C��1�/:���`��~k0�r1dbY{�\�L���Yrd�tQ`�L��"�x_��[]��b������#h�`A�A��P�*�� ]�Quڤ�&-���(���\��{Mh�m�ID��n�s�_��M��5��Hd���%��R

�GIY'O����Y���A�>�@�4:�A夰T_�C;Z�oCV�ѵ�z�C�3�	��iN�)&@���ڨ��Qa�_�:������&�&+����Nb�Y��j�df<��B#�����[��|��:�������wؤ/@�}��:z�N;�澂l����m<��
��=����a�7�O�I���/���ӊ�=�,�w��I�4w��N�𧅣�H��;�� ��ŋ|� 0pHM:�C{�m=�t0z�F!`����������Z�{�c4��Â�5��m���/�R�6;ߧ0��������?	�G]��OG��b.Ѓ�w�'=��X2vt��� s  
�����Z_� !�
G��v����4e���N;��w2'�T�E����;ᱢ6>~�Af�j�l��[��&B�!��X��} ��޳	�JG���>��M&���vki�Wx��w���2�d�+��=^ ��^���.�lmc��_oȆ��y�T쨣mj��퀯���h����wh�
TO��(�o��	n�b��1M�=��i��2ȍ|�$+G�7��z~�ݻU�������gld�'�\d��œ�b�,X %���}Y�	ǂ���#p�޾ױ�x@S�p1f��]��������*X�!u��*�`E�E�׸A9�d�Z&5c�|��>�
��?o�kpM<E!��}�R>��� ��2GU	eÄ��;�=M�H�o�pX�oJB鸿��1%���g��8���F�}�wñ(
Ɗ�N4@Ǝ�g�ՠ�F�iO_'�ó�{_�9�78�1e�;dL�I�Ŏ���	���
`<(%~�"�Qҿ(
sn���W�g
��p
�-�]�;��f�:�� ��"_+��	����B��}e�� ��6d�ˠ~ݕ�c��/������6h_?v����{3_�����^�?+����j����˾���ӧ~=��ɮ4j���Þ>ٶ���S��}����kv�l�ullO�����~�
�%ogL��mz7�(��߲����4I[[�LPr7�"o��&��4�/�K����
)/&h�m�$K��%�Oe�*#���]�%o��g�u��m2�n�EJ��=&�T�..�x�V2�y�~�L�?o5ɱW�.��oي&��Ky����<�3z�c�W�������@OJ�dm�ַ��`�}^��#F��	Jn[�6Ivc������	~��o�]�-[�L�[����k�c���H$�	�V��4�\��AP�0��5���e���Eޚ��a�,{�Fh�q����;�������.=�E��aλ��(����#�~|�0T��4�X=�Aٹ�
a�[fx��n��=��e������c�[�O~kN��g�YUK'��Fh�-���ZMV=(���xk��U�n�@iq�F�5{X������'������7PN�w�	��F	��zՃrհ��=F�z�S�A(�*���Я� ?�(~��k�&�Պf�B9�W��r��I�PGYO��+%Mۄr4׺�(��9�F�VW-�r@�Z�	刮_�(�����Ѓ�]=(���=fԵ���S��cV�x��?���Ñ�����:�4P�+�h���Г#SݏY�,~?f�P��^smt�� |q'f ���!e���	�u��^�������}PZ|�@)�i�����h��y�_�RԹ��|�h[X�0y׊4P��-�F9��=\U��@9�k1k��}��j��}��5��^�QVZ�x_����s��=���\Kh��;�-�Z_��N�!6P�ڵ��F�<��Ձ�b9����ŭ����]�@Y��Z-�;:���@�b;(��}��kR�P��Q��^;_�0�?0Bs�f�wW3�Pl�5B��5�oFXCh���G ����ڿ�$]��l�4°��@���l�a{�h�a{K����)1°��5��u�'�[PWx�������|:�-�ځ��%z���-�ږ���ޒi�Q��~
��y,����-����-����'�=���@����(-n���{��⇶B7§�ѺP�
��S�V�F��Bh!�t���=�#z�'mKf �?��Zh�=R�ޖ�Ɲh�a�ޣ�Q����*f��Xa������+b����%�(ǜ��rؾ��rؾ�}b�N]{�X�[2�6�g:�%36x��{�����@(~{����bܻ��8�O����Ѷ�P���@��=@�|��#h���G*��O��9�o���`�z?ӁP����<~�@h��+�0��	������"P����ׂFۿ�~�]��f�_4�5���}��L�'���L����u����q2�`5�{L���c��9�Q����1M���ҵ���jK�ІVI'��g��%sW�b2��<P�%sש�9Ÿ�sPZܒi���+ŏ��1�δ�0#�_{y(��]������Oh�(��Z��zCa��e�@{ ���@(~���
�gmw�@�W)���tp�w�|��n!�(�n�@(~{�7�Fk[k�*ʚ��;�
��}��g��}�%P��m7i�o�o{ 63�H��/j�VO�k~�E���_�k~�E�}�Fg�:���m�up��>�JW���t��cN�Z�+�F'\99ќ�l���՘g��Q�:�`��vʃ�w�Un��)����0�h`
��݇լG?����SL�[?�����S, 4k�����D��ԁ���e
B2C�P�N��TД�0g��T,���K��I2C�RXR0�����4n�aA���h�/P|�v������l����EJ�C1���ܰԃd#i�|��%3J^&h2�)]����$KִC+4ĺ�0�3Q�cmP�R���E=PNߚ��*��r-���@*��%�Tɮ��P�p�+\��O��w��Q8���~�W��)v�F`v/9�Ñ઼W�B���x09)�*���Xx��PE�>z�Q�~�8�pb�+P�Q�&�FY|��ZP�S��,K�(���ZJ�j��=�D�� ?���:A���|!�.��CK��R
����~9�A�G��;���_�h�(��=�>wF���K�`;�K�����x�{?�	�t�'��qo��}Bګx<V�^��#JU�k��J�t(���������Z���렴(�Bϑ�e�\�3Iq�:��J'��F�8
a��=�~�X��3��qo��}G����l
���UgS97�im�tU
��*�9�X#/�u�f �LRY#�\_e��Y}�3Ih�0~Ii��	Im��{Z����~�����
�9���עB_�R(d<P��Kk�r�Z�|�"ŷ@����>�ц�Vh��(�s�n������>Ґ�z�3���
�x?��B9�k��(�{��F9X)|���%���1G	�qN<�:(����b��K�d� i�Q�*��1��B�q�e��dHk�`q���A(^�k�%˺����Z#\&��п��FY��V�A��~/�|�BsHk�`q��kBET�FY���6�g{8L(�w��F�
��^^cg�Il��SKm�r[jHn�n�6�AHp��+R\���8�qHs�r�]��F{�C�h���+d<S������<    e�^�sr�lH{���_O~0
I}��M$���|eH����^�e���2M��ɤ����uXNQ�T8XڕK�ᘲ�
��}��hf�zwꁕÔ�KW��	�bx
N��t<X�|;�V,�+=	�GK���Үt���/K��]���A��ﶗ�/zƃ��8속�2�P=����S�`Y���Yn���ݵ���w7K���0n���0�e�-�P=��X�-�w�,�߇�( 3Xj��&��(J3.��qƫ���0����4ّ����C�K����H��y�����K�G�/XM(h�0�p��0�M�k�6|=�,m���Cn�<_��&M��H��Ї���`��6T��B{�<m$M�v��f�ir���j0,{��`x����`���&�o��ܔ&��_�Ґ[�}�[�uXj���R�UK
�zk�Qq�nI����K���<N�`��`55`I���/�d3܊�&��bI��p^�l�c�.������kE�K��B0�i�B(����_/K��Ɋ0�ZCc�n����}�Ӭ��!�v���`��6T�I���발��R�aiW:,mH��RߖtG�����=���4�5��/K���fh7�y0�X�a<����-���҆�\������%3�?�x���5�a���,�C�|����R?�X/˺I�͠�s3�u��kmPCߝ�XC�y�5�d�8 Ϡ�\!���2��z��?�+'�0C�����r>���,�:+�Y�pb1��΍� _�5��0�w�a
�uZ��8N�t	����R���O>/�!�H�s��_H��
�\7�t�/m��@����,��`�W�q3��1�v�5)���w�����܌9i[�I�0�P=��`�s�0��#���V' ��9�H�7��ӆ(�3�އ���l(o.m�`mt�NlK�(Kˋ��߫q���KlF����Q?��ʧ@���;��6�`��Ǻ�C=f�c����y�oH��ȁϛ�[�0�U��`�Oڭ���sm4�;�f�ęq�v���<�6�o6!�VQ�2���N'v���X�-��&����sm8��gU~��Y�8�vg�����`���u�6��bx�5��,�w0h�n�j�]h����t9�����0��D�y �B	�B.tI7 ����ιuQAg�vv]�vm��e���@h�]ہLU]�Q��ֈ]G2�(�BC�W�
���&m��;f��K]<>��U#�>���~��P!
��K�
]Q���uWѐ+��d��F\��v{@��D��g�0@�����o���|C�%)�/*`ʤ�iº4? ��4��O��#�ԧp�tGʨ�}K8_H��0��xߨ�!��J?Yd������I��>-7��q��O��r��ِ�ƁC��7d��BZNL�8j4�f�lM
�a�QP�44_HCxD�ۤ�|=�c�|����0$�HC�����~ N���g�B=��LC�����<��]�;�} ��s9��E
`;�����8��sAQ&���Ai~���kP�R��(d4 �J�������J!jTN���Qn8�!`�(M�����p�y���%.��Oga�:�L���S��%�i�������[�,s��__/�K}��*��@��B7r���|d�i�  ���)�ٚ�|!
�2���q �w�9C@Z_/�!���:.�5^��7�d�Ir
�9�*PA�j�=R<�a�)�@@���B��$/ �HW�B��(/ ���_��S����S#���i}��q��Fy+���`�z���+Cb�KCܪ�T��4�ق�s�����|!
Z��aN�~��wgԃAJ�'
�0�V���Z�l�P7i��B�Sbc���A+��͌}�E=���|f�/�i�3]%���_����f,O>�r����P�m�`����z���t��%�4J�v�s%�F~Y�g]�\?��`�v�a�ocI��8FH��`C:-�v��a�!�~�F0��l����+�Ff�
i��bza�)L��0��T�w��	�[�@�ź_�ʬ�@*�jR2V?���Ɓ�8�o��7�[i�n�
��ڮ=� ���Q�te��x{�U�:ί�>p��L��+�P�a���������^�$�a]�n��r�C�t��emEWd�������Р�w�<�$�vxP�NC�0$i7D+�_@���G��M,u�2��x�O�3���(˳n���K�@h������H@��F����% tE��D��FP��3�2D�	�c�+
ih�>va:��+��Y_C�-8]2������B��	�!��fihH�Ԝ!3㓚3v6��a]sCʙ��lM��P;�c��ihH�ҜAṼw�0Ѐ�U���hU����GU�S��&T.�'�H=��[��z9ֱ"�J�p�����2��r.��	3�*�߁p����@���pѐ���$�~���z!I��=�s�L�+0���\���u�{@�V΋�%z�y��2ׁ�K��O�![�/�!�a�!�!�X���T#ٳ���l黓�e�F��<`���wÊ^'}7�����A���D5��
\�����w'n����= 
�|`�������= ���;�:�{@��;�P������.}7d����!�H����wC������ߕp�sj�{��o��xWi�{������߀l9�k���<���z!i�`�&�NB@(�.��N'��:���,�90#6�6"B�t�= �(^t��ti|�G��=*>�v�
X�PY��2U�Bz�(, ���y�>+b�=J�>+��k�i�!�\>b�X���s2C��@!����$1 jg�@��  
q����Az�b�F�8�Ϧ��7�����|׫�}�u��Ɂ4�|�\�:Ӫ�{��(/��Q_C��}�{�+�����z{!\�Ӄ��c���恍���+^�Z��" n����R��} [s>/��v ǐ�_HC#�HM�Hw>��s��p={	xW�r`枭J�0#��� �3����f�gU�Y��/�j��F+:=�
X�F

�
��R��B��, ��}jĥ�R}d_zT��O�vU8�s�K�k�< ��������������<���_�����n?��;�ӏ���}���c�����ׯ��>��e�]�����o
k�������>ݜK;KskJ�h^��t/�ui������+��_��n��� �Al���Al��z�z�z�zy����ߞ��_x���^�������~���~��y�k���k�������׾7��D���=��D�~��G�z�G�Q�E�P�E�O��D�N��d�z�5󯥹5�y4�fk�����kB����5�y4������kO[V_���}���κ�};����]}oK�Y}��{W�{��w�{��w�{��w�{��w�{��O��%��Z�^���k��kqz-N���8�ⲜW�,� 
?~(77曆�{��3$�\Ӹa�ay��������g�Ѻ�l�f��㛏o>�������-�������'�������'���4�i޿K�h^��t��')PҠ�BI��%-Jj���ы���m�n+v[�ۊ���ͮ���ͮ�^�z��Ů�^���kͫٚ��%/�x��K4^����h�D�/}x��K^��҇�>���/}x��K^����$�&�5ɯI~M�k�_�����$�&�5ɯI~M�k�_�����$�&y��m��I�&y��mv���fw��mv���fw��mv���fw��mv��-�Z��Hk��"�EZ�Hi-Y�M��2�e"�D��,Y&�z"��,zƢ',z���+̖�2W��L�D�^���{��y��������޿���}���t���<=������^K���i?=�'�������3~z�O����>-˧E��$��H�^��Ҿ�����}/�{i��Y"��Ζ������-�ni{K�[�����������߷����k���Z�׾������o�áo]��ҡI
+E��m�6`�
P{���������_)A� _p��QT�z�C�A� ����+lA��8�C�zp���C����g�4��
n�ט%�#�!`t�C������IMc5�� �� �8 &R<�ч�>�����=&���<0���~`�G8����xp� �x&��!�, E1�38)�t�w	�L�
c~v�a�0�al�Ǵ�-'��Lg�:����v�3�Mjt!D;�9�΁v�s���hg��G������PH�&�>���@\�:ׁ�����q��M67��ds��M67��ds��M67��ds��M67��k��^�즳��n:��,�< �2�y �j`��<�0�	0L�a���F/d$0��#+��L�eb�v"*�l&�3�	�L�g@� ��& '9�=i��w8��Ti�66��ld����2���P�@�Ǟ��8e�T�����b���/	 L@`0� �&�0�	@L�#��!�0��\L�	��`m��=��X�cm��=U�����\l|F�3�����$x$�#>��g����k�5�ds�M�9��Ory�ϛ���X���Z\���Z����Zܭ��Z���Z\���Z1�:� ��K���5�d
�s�9��XN('�ȉ�q�8A�N'����R�Q�0�g>D*H2JYF)�(�ϦڔA�Rh��L D  �?�������rxZO��iy;��r�.�š�r��q�P]��Cuq�.&�0��9�8CΒ3�l9cΚ3��y���U��v�����Fc��a�S7�qS7�q|�?@�w�q��rcy��Xq��N;@� ��V;`����^;�� ��f;�����n;����MQ�T�MY���Ma�T�Mi�\����]B�K�w		/!�%�������B���P$4!�	AK�B��x(D9�!ap	�O����0��M<'I*!K%���<���2Ub�X媄d���t)��< de������BfVH͊�qה	�2�P�b�XF�A��b�I)	�X �2�����=œ�2�b_�91|;�-��ĤHti!}=d���������c��;���C@#�;���������-u?䊇l��U�	h��?B���|��$/!�	�O�B��)Q�L
�xO�g�Ȟ�{^��i�q��K�&�9�<��E��XQ�(R��1��H�'H��
Z�Ͼ\�q� �-P�*tB�N�Љ�C���������vq���}����w�ja���P��~�&��H̊���
�Y!;+�g�T�H�
Z!E+�h�$���2jCJmȩ�gO&�ȫ
HI9gTH
HI)) %d�|�?�=������2R�C*�H���#s�b���ө8��ө9��SneN��d�O����O��d�O��`Q�X�I����I{���I|���I}���I~��w�8�d��1N�8�d��1N�8��_���`�v����$�u}��_Ƣ�I����I����I����I����I����I���x�	� {�<��0��� k�4��0��=S+ql��'�'R�'��'���}��A���	oO�{B��0�c�+�X)�J1Vr�_����%�.�vɹK�t���¦x:g}E�)�N	)a"�X�%L����0�&R�D�9ׁ�ʢ����6�2dR�LJ�I�39ٛ2kr͉�U����$� )'%Q����$�=��LeƯ4�jLq�Tg@FJ�K�w)/e�%�:�	�Nv°��P�c';�	�NPv²����g'<;�	�N�v´��P�k'\;��N�Y�:����G�j��$3m�Ȧ@61��	LL`b�T9�rR��y/bg��I��J'�NJ��:�u�����&|Ԉb1�,�xF�%����&�´-T�µ-d�¶-t�·-��b+�r|�Wv}���5��)n�{ꚦ�i*����Wۤ��n��o�'�/zM�k�_S �"��'^8�N�p�/�x��'^8��95~h�D�'�>���"U@�
�T�* RD��-4�"U@�
��9₠�}H���!�TPy��X����'�<kjĦHl�ĦLl��<�8?k�=�8?�d��������G�e�,������S~��OY�)?e�,������S�J�^I�+){%e��암��p�\'�:A�	�N�uB�s�W��	�Nv����@�b�kh�ᙇh�y�f\�Xb�%�Xb�%�Xb�%�XbM,�\�t�W:�+���J9E)�(Ϭ{/�(�����S�r�RNQ�)J9E)�(�����S�r�R�����F(����Vh�����f�G��oΆ�z�}Y�b�%�Zb�%�Zb�%�Zb�%�Zb�u
�d+�V�� A�cQ �Su#�>�ߧ������S�}ʼO9w)�.�ܥ���s�r�rr� �r��L�9����(L�G�(��v�nJB'6�5�]�S�©D�T�p*Q8�(�JN%
��S����EGM�%@�6�����%�e���v?������쮿&�t��I��[�nR�4��4���l�^�^�^�^�^�^�^�^�^�!u�+��9�n������zew���^�]�\zYz���^n��z��r���˭�[/�^n�����ޞ������=��ioO{{�ۜMg����K��Rz��ǫv�jzd�ړ5���G����>|}�5�mۇ�
�JaY),+�e�����²RTb�rVs9����\�j.g5����Y���rVs9����\�j.g5����Y���rVs9��������W2aJ&LɄ)�0%�dL��	S2aJ&LɄ)�0%�dL��	S�Kya)/,入������R^X�Kya)/,入�������^R�K
{Ia/)�%��    ������^R�K
{Ia/)�%��������^R�K
{)�*%Z�D��h��R�UJ�J�V)�*%Z�D��hҮ�v��+�]!�
iWH�B�Ү�v��+�]�V
�R��B�j�P+�Z)�J�V
�R���g�̑��[���r�p9`�0\.������r�p9`�
.Up��K\��R�*�x	��ߘV�`� ���ԟ���S}��G���O5�����±[�w���ٽ4;e(���uy{\������z{\o���q�=������N+�i�=�L����ʝ����vzl��vzl��vzl��vzl��Ԛ���������>�����#𢡊��>�����#𢡊�/',��	���r�b9a���XNX,',��	���r�b9a���XNX,',��	�%M��)�4Œ�X�K�bIS,i�%M��)�4Œ�X�.`o{�[��������-`o{�[��r�m9��[
�K�u)�.�֥кZ�B�Rh]
�K�u)�.�֥кZ�B�Rh]
�K�u)�.�֥кZ�B�XRKj`I
z�`e�lC�mH�qm�؋�{�߽����w���7����iCrڪ��&�������RsZh�%�6��	�M��ƻ���`V`�`�`aVa�a��BX��u��f_��9Z�/?L�C.r�p|�3_!P����Y�Y���y9>/���I>ٌiX'.
�L��)X2K�`�,��%S�d
�����V2�J�[�x+o%�d������V2�J�[�x+o�
Kc)`,����0���W�U�����d�����A�/(^P<�V����� mh+@[�"J$� �#bD��=�S�<�Ň�D�)�[m��ڻ��.n�`Z-�u�g��� �d��ޅlB� [P��dO�+_) KAX
�Z��2�Y-fn�J6�����~o�{?�M�����f�7����=@[t�7K�y�,Œ�X�K�b�R,Y�%K�d)�,Œ�X�{��]�����C��[|{��+�x95�����S�rj^N�}-�ki_K�Z��Ҿ�5�ݞ��B;_Nͻ����{"=?S���8��iCN;rڒӞ�6�|�5:1
�v�u'I�$��$U��J�TI�*IR%I�$I�$��$U��z��+	"}%>�S����^
�|ý��Po�%ϒc9~e_y��J>%�r���u�u�]LSG�=h
B?j�kG�=��A�{�=�\��cRͩ)5�&���.gs�������l�r6w9����]��.gs�������l���	_B�b�;vرÎv� X0���`�,`�Xp	ٗ]b�%�]b�%֐.�c�A0�c�A�`]N�.'X���	���r�u9���`]N�.'X���	���r�u9����q�Q�1�O��D�������6{�� p��}�)5{@�r�;��}X^7z�Ǌ����r�Z9l��V[+������ak尵r�Z9l��V[+������ak尵R,U��J�T)�*�R�X�K�b�R,U��J�T)�*eN�̩�9�2�R�TʜJ�S)s*eN�̩�9�2�R�TʜJ�S)s*%�$�����RPJJI@)	(%�$�����RPJ�k���	��	^�[S�G�d�p��3L�agHΒ�%9Kr��,�Ya
�`���$ &!1	�IXLc�����$@���2�����\X̅�\X̅�\X̅�\X�uM쎔�bv�pI.��%岤\��˒rYR.K�eI�,)�%岤\��˒rY^��=��͸�:�B_���;~f~E}�
��A��;(���ݑ�?�w��R���|�������O~���_�������m~�����]�݆�]�;�w��g�P��M�ۛ�G�����?�g���H���>�#}�G����������{�껱������n���I����n|���T�~��N���|�?��������n�����������~w���w�����~w����cw���ݱ�;�w���ؽ�����|w��w���8���|w����@Z ����E�g�+���-����][0��7f*-`�`�c�zk둬�cY�G�ֱ�������Q����	�	�w�g$2I&�d�0�f�L�[X�%:�tϛ(��Xջ��z	f��k�o�ݎ������/������/������/�����O�Z���_k�
���*�
��o���*�
�7kμ��7���%��_"��%��_"��%��_"��%��_"��%��_"��%��_"��%��_"�m�}o�~���m��{[�U0[�U0o&�aFXF�
f�`��L � ������}ێ���zm�����knس=ق�5�z�z�zie]3	L,�����+�ʸ�����ڝ���ڝ���ڝ���ڝ�+�����ܹ��՚��K���5q�&.�0��&�AԙY_�()#)C�3�<�l����y���Ԍ��:<��cT�Ƕ��w���V���#O��-���l����y�R�K�*?��O���K��R=�TO/��K��R=����R=�Tǭ'��9zz�����'���y'�׺�s��Լ=3oO�������=+oO��K�����z{�ޘI5�1Zf�-�ú>�M��a`��ab6�ad�e�;�0����,��D=l��H=���L=kt^/,��T=l��X=m�nnU��ݳ}�l�=�w��ݳ}�l�=����չ����c�~����w��E���|���]{E��m
}�`�5�m�x[#�ֈ�5�m�x[#������7����)3Ӻ�nI�J��۫��j���o��۫��j���o��{�3�^�֝ݺ�[wv��n�٭;�ug���V�$��m�ح�5b�B��݂�[�w��n)�-�{	��ޖ���[~w��n�ݽ���kwﵻ��}���ޞ��s�{w���9�5޶���k�Բ�KH�=��햲�R����Ҵ[�vK�niڏH��ji�-M��i�4햦�Ҵ[�vK�ni���-}�Y<\��o�ܳ��w��ÿx8��s�'b���D`".��J�Z6-{�-ˎeòC8o[����6l���Y�,|?�E�B艡���>|��zX���{X�����v-����������iQ?-�{>-�㴨������E�����Ӣ~�$�6��M�i�x��L��7ϵ���9�-��崶�֖��rZZ�#���-��崶�֖��rZ�N��i�9-=�A��-:�%������bsZ[N��i�8�� }o��i[|ZKNk�i-9�%��䴖�֒�@?��֒�ZrZKNk�i-9�%��䴖�֒�N�ޖ��RvZ�NK�i);-e��촔�����.�+vAz�#���7(d�-\���pA��1�e�`B@!�X.���`C
T0���`@4`� t0���	�N@D?��R�N��0`�,�q���/�a@d0� �0�y�x^ �� ���P/�z��^ ������p/�{�b�6Hk�� �AZ��i
�(Т@�!�=k���D)X�@�^$#��L5��&�2�,ΰ�C3�8D��j��|b����<&
!T�B��gFD1E
\x �����B<0�]c��o5�=�IA�Q��0���0����y�{��0i��@A��S1����PN�I5i&Ť�����UdHI��#%I��N�(��>����jx"�Z�����'�_E��~�*�%%&�Ą�����y��w��A� ���v����nm���Y:+�&�ل4���:�Pv����� g<; �ю���@�jX;𰁇
8R �����%0)�IN
xR �� ��)P)�JV
�R ����|t�&��/�_DF 2�����#��Gj{�����=R�{���Hm���#��Gj{�����=R�{���Hm���#��Gj{�����h+ڊ��b��h+ڊ��b��h+ڊ��b��h+ڊ��b�-�{���r��\�-�{���r��\�-�{���r��\�-�{���r��dm/��^��� k{A�����Y���dm/��^��� k{A�����Y�+��h�9������r�&cdR�l~��@(F9PʁS�r`��x�@,v8�Ág4q���X�@�9ЁE�s`�㝼�I|�̷I}�ܷy��~����l�,"f9Pˁ[�r`��E$�h���8��3B�Br ��h��#"90ɁJ�\`�%8�@�V.�r���\�_��=tt�!�@IN:�ҁ�U*�B
������������Glf;P۱'�p���4�Y"DȄ�!"$C�<P�#$y`�Mx�@��<P�+dy`�]��@��<P�3�y`�mx�@��<��-ty��a���s�����<��>�y ��(���=��F<z ������2:�ѱ'�t�H'�����������_��^�f:pұ�+o��Ŝ��q�7px
<p����w��@�<���4x����@�.<��
p�X� U@* p
0E�~�0�'a������'F?1���O�~b����D�'R>��O�|"�)�H�D�'R>��O�|"�)�H�D�'B<�O�x"�!��D�'B<�O�x"�ߝ���w'�;��yM��ȉ,b�w���h�D{/��B�,��B�,�̚Tn��B�,��B�,��3`錖*"�����D�':?��eO,{b�3���W����a�"��b�2��c�B��d�}1�q�˞X�Ĳ'�=��eO,{b�sj���eO�xb�#��Ĉ'F<1�O�xb�#��Ĉ'2:�щ�Ndt"����DF'2:�щ�Ndt"����DF'2:�щ�Ndt"����DF'2:�щ�Ndt"����DF'2:�щ�Ndt"����DF'2:�щ�M�n�w����D�&z7ѻ��M�n�ws�x��g
y��gJy0l9�7Sy3�7S{3�7S}3�7S38S��l��7�)ș��)����LQί*G�S�3�9��T�LI�Դ�j����k��l�Җ�m�▩n��o���p���q�"��r�2��s�B��t�R��u�b�Nv����o��4���lM��3�0S31�8&��3�0x]O����L��T�L����L��T�L����L��T�L���܈�QF���dT��9�!�"T�Q�'Ba��D8�{Vt���Nuϔ�L}��L�ϔ�L����g��ᬓ�8��Y'�:G��8�o�ٻ�T\M���\��������o��g�{��g*|��gj|��G*��-3;0�>S�## e�����2RF@�H)# e�����2r�d�����2r�곁S�4�Mk*Ϧ�ljϦ�l���'�=��	~O�{�� ���'>��	�O�y�5��$B:iO��!�����'B:҉�N�t"�!��DH'B:҉�N�t"�!����%B:҉sK�t"�s��d�J��dr�.'g?�3�̅���2������DH'B:�Ɖ�N�P"�!��DH��Ҁ�ɚ��)����1�S�7e}�.�p�'�8�o	'�gJ
�����%�/�	����t�S/
LF{Q��*2�lx2�y�Y� ;�y��ɔ'[��y��ɜ'{��Cġ��a�0t�3��C��Ѱw�ڙ��SV�|��� ��bFWN���Q%��ʉ.�̋�f�f&"41�yO����N��T���f�2��S9;��CΪ�Yh�ċ&b41��M)�!e<�����2R�C�xH)�!%)�$�����R�BJRHI
)I!%)�$�����R�BJRHI
)I!%)�$�����R�BJRHI
)I!%)�$�����R�BJRHi)m �
LT`����D&*0Q��
̩�E&*0)��H�
�Sұ�\�t�@:Y -��kc��.��H�,���{,���{,���{,���{,���CJEJ���a
�ĲbX���h�Ds��H)�#���H4G�9͑h�Ds$�#���H4G"9�ȁD$r ��H�@"9�ȁD$r ��HLJ�yL��0*�PI�ʺ�8�9OaT��H�p��_p��_�Ӄ�h~
�='Gz�{�).���A�D����K����K����z�A���=�ֱԢ�%�^��Us�"�}�)�̰~M��=�c���tm,g������
v��$�N$�Yj����1���tʰ�      �      x���Ks�H�.���
̦�4K1�p8��Ž|KJRb�,i�����H! TR�k�d�f1�צ�ڬ{��.�?r�|�#� <��J�Xee�y��~���w��9�Z��.�3� s/��gG8>��8;:tB)e�_����x{i���w��D~�{��������_�9W�l+w�*��	I.v>�����/u^5�/�ؗN$���逢��(&�sQ��j�c�^�EQ;2N���ҋB�|��=��C5���rD �¹�[�e���ݯKU,*�@ݷy�_~�^a��o��/:~��t��}_��%z�õc�@�w��^�4/n�g�`�C�����YQ5��'q�
Gi��8GY3�{\���֫�h���{"�H�q�|G�tV����`�9��\���4�}�y���b��ͽ��;}mWY�V��,&��B/��TZ�X�Ը���,�߹'�7�	������yU�2{���a�fvY�ʚ�G��_����u�(A�D^,=�X,�:o��{\d����^+�µj��v?L�ȑi�H��������
|�P���A��]��j�pD^�#
���"���;�]]�s�P�ٚ�Uv�]BND��O�r�s�����G�H�E^ޮi��k~��I�~�D�R�����!���\S:T��8�%6	�c�,	�<�珟��=Q�ӷ��U��]��EJ?Ɨ�� 	,�>g�i몬��k��{U7�S�b�v�ë������}���$�{~�|�˛�٣������^/w]�E�����	Bb��}���`��Y�G��iU>��aU���U�R墅|��ȃdI=/Nln/q�S���}�7�ٿ� ��8t�0N��y ���w�˅����-ߞ�Z�7��걨��d !	q�[<��s�P.��/�i�:[S�}�e��;��C�p�/y�x28�8S�^��.Jb���083?���� �߸���7��_��:
��ŽB�s�oʇ��o
l��}D�>��F6
����x(l��-�@�����M�!�׼vbOrG?�Ev�iS�>,
�Y�PL��(�s���s�$�A�_��؁���&�?�"����܋��(?�F�yW@������3��,2�w�u��z�](8?� �����Uq�w�T�I^�U�5����B����Vr��xG6����5Z�_>��E��;܃$��h�x0�`��{1��!7kHР'��	Nkۉ�}�>@�u>>>�/�Ԣ!5��WU�����?���ѐ"̪$M������b�@H.�F���>t���Q�5��ܿ������
��\�L7��Y6��a��E�����R��;���F��W�w�FSwJ�&�s8���[S���C<v��2%�ǖ忌�+N��(�o��S����=��G&q��.GS�0�4�xIS� ��,�1�@BI�U�K�\�/n�	��`̺��n��ۈ���\�j��}���P���y�H�%Pz)>fpW"�"+ ���j���x�Y׸/�s�7�_�ɗ�� *Ә���]-���ǧ��_ݗ��R-������Ȁ�aC��T�ˣ��T��q��G��)B'X�V���ϝ�y@/��?w���.#�OXZP̰a,J<�Z����1T��-�w)/O�'
9́��^�ׂ��Zt�����*��e��CTjD��o��ISM�%�S��sV�u����Zx�2\����:뾎��$M�D��,��:)��^eῠ��t_^���{��P7��x���ǑJ���}x�P��j�w�=��QX� k��7�Ô}_�8P,N��
Xi��|ߐ^^�U3�z^�p�X��SUW��o��.��9����ᮎ�\��l���B�$�cmu[�O�rPњl�3��
�ǂ
���<�1��i��W�v��X�]�/`o��$u,��]tp:����t�XA%�1��qm�C~��$�q���D��W�6,|�5�=wh�$����Ԇd�(���QÀ�����8/M�6�n�U�|�v��0� ����=�f���7��f1u"ߋN��W�=����!����/tp�6���`g���{�FN`�_U�׼����D���9A�U�r�b|���{9�8�
����-^���}'a�D�J+�g4S��W�{��G�,��^�����+�~ޥ��|�x_V-�ӧE:X"MQ2�W���O�J&*2����t@��W~{K���i�He��y�*��y��{ '��hW,�|��Ѷp�|Hp8����`�cŦ+��U�jw�h��V��xL�����s+aC�A������\�|��`C@����,���*;��2`��z��[�V5]�>�]wsƓ�6U9{�J
�ӬnfWm�����%SID�ђ/���9�5�
��F_*N�ć��CH�x�rH4�B�Y��^����ԡ#'�-�T �7 ����ӿ4+_�V
A�8��q_��wj/C��B���|���R�!�\
�^�ނ�_w�����
ڤ��a�L�H��U���+!��
�){�)\��,����5|'�h��?���"+2� �����^���n�~A�X���W�\'��}6^Lɜ�I����Dp��s�o����ۉ#��B<A���.V���x�=r���q��J���,�����NE�#�����s�9)����m�2E�g�
��Bu��X�#T��{���2�����v��������
X[wO�O�r=_.+F���h0T�:�Ial;�=HL�R�W��u6�_B���c>�e�^T�<W:^���{x���v���C�<�ݢ��4��|��pQ	�C�y�(L�����Rvu�}�2��9�����Mׁ�{���H�N�i�����zO�u�Zp=H��	� ��ZHo�=�h�)��+��i�cX��4�L=�۶`��O���M��[�7�N��}��=M%+5b/�Pѐn�_rXL�E_�U];��V�}��]��dt_b�!%B��%"��T��T�˚����*:�j-�u� �?3;ͪ�6W�Qusô���U��w����î��e�L����J��n�=�7�xS-6g�wqX��j��V�����p���R.#�Ĩ�����b��Ż:��wM>_/ux���4[���;AN�	}^��P"WE�����@�7�:�Q�������.��sY�Eݕ%���%�&g�_�����d���:�ժ0n��iI?�h Tp�󼁐�/f�B����H�y�)� ���4^_ⶢ�.[�'�b�Z B-�ˁO��ƨՔl'�Jr��W{갺�SK^
2�.���?0R�+�y��^dT�S�)C%իU�A���|���؄/�X1��=Z3_h03�E��Zֲ��k�3��(�:>��[I�_�7e[W3�k鳉A�%�I��R�)5��+7taN�<�4����]�0Ag�M�I��*۽Z�'
��k� ͐jҕej3��d=
u�
��5v�#5PS����`bY
�`q�����
Ɉ�Y�-�n�أ_GX�=�{fH�y>�jo�X�q���Ю������=�b)��j�B/�+~��Њ��*?���5��4�`�f���	]W���t�����t�O��+T�A�����_�>����T�"o�׈���;��lڣ:�������!D�g��";��u�5�e� ��^�g�X5uN�����^ȓÐay����g�JE��|h�)l ��Y/Ձ����w2����
C�^:"�ͫ�\��/��eb�+@���ۮT�UWB
g���Ѓ�ɘ���Ѫ�\?鮜���{��E,�ƅ��1{y��ghPX��Ҳ�s����X'Z�ќ����T���������d�ve���:��Uh�����}�t�;x2W�p���ֈJ֍[��Ue��!���l����G�#t���y@�}������|�5::m�� +w`y���N��9�[���yWWN�<��S�|�wt�
F|=kUG�A9�uy���q;i��j*� �:�T�^�j��H,��'�ڸ�5�CI�$֒��+Q �J�qA������X�Y�_!��	��Z�[,8�aF>ǅ�?��ˈD�	/N���$�EYyP���X�Y7�nG%����Ȁ��'�|0tlRs{�qxp��H�L�=O?�b�Bx�\�E_�|^g0��?	�
�U��f���WE�3��ƢS���%�E�,�+b�s���
��rǽ��`��}��u����7"%�H���2VVv�
]2I����'fk�K��/���*ݻ��-<ka��J��X�j���ZH'nY��B�k��u�%�6��Ւq��·}��ݗ���z���A_E��<+���k�rͺ�/��٤�����ۈ8T'�p�tq�F;�6K�0�|W}�YI�4. �ScK�iH��U�C�}�_u�9/��J&Ihh�Z"^%v����4�ǡV)�7V�%^��l�s:YȺ�+�0�IA	^ �]���.ͬ���i��~�KwQ+V�H)���"³���L�j���1o����w������ٔ#x:۬�=�E�����=�@?g����n��YK/�l��ټ�/�4��ӏeՔ�����\���qf������m��Ɋ�3��]ÞF��3�����B�&��E��ǙZ<�I��<���l�b�������s�j���o&���	���� �U��P�C���o�j��S���6")ܑ��	n���>nr��}�@�=�g��J&�Ý�՜��4�<�=��M�&�?g�O�r�6�֪��];����_2|�l��{S��צ͘�NV�@t��X1�R��������m�.�]�?w�nKa����w��z���G~��kl��
Z��Z_�Sz�~���>�E~�櫟�2kfl��X�?!s�쨁����*Q?��"��;f��R��0���4��E	����K`��ĝ�PaS*�k,Ϫ��c޸+?3[s��^��y�r��}\z7�f��~�H�[݂�@`�/cA�a�U�����fD�Ǥ�D�������Vx�9�
�������c�#D��2Elƣ�Z$p����
)ر�W���o���\Y��Jdͷ�jq
��r�]�t���?�7���h��0VB+��AM��~Z�+���\��U9븍u��L�Fo޸���v.l�5Y�'�D�'m�9�$p��TE�%��ކ�g�lrk]1ա��&�U|���݇�
0�z��f��a��	A���K�A���X�[JF�V���6�>Д��V���D)V\����y�G�2/o5�O3��}���o�b	+���M'Y�5o����q0t�{�amG.�
bv���J�����8q:5��"f}�G�a���!�&u��l���AL��4���r�+��2S���o���V�ج�� �wmP��E2fp�-r)$F�6�x�擄 �5��ڰ$�lݻ�F��O�N��O#����ڇ�����!�s���`h��	���������|�z��/fʉ� f(-�>�⯳�}�^f�������40�n����/�D�\�)�6ʒ�T��z�jL4�^��M��h�{�f'�3"�8�a���n1S��w�e�E����j�XG8I8��;H'�bM�ȷ�X�� տ�4��ā^�A�]K���'^����ǩ�ek�Yw��gy��<=@�c|�b�ڎXCf&V7N8Qs�`Ә�����2Ma�5��}�0�E�su?�e�ēQ��Y�}�1�h3���u�O=O��ͅ�<+)C8w]}���̇*$�X�/���`o\�A,���DNz����M� �߸'�\�u�fi�����y.a��&|H[�2c��C�(���&�
(�@eӎ��eq�=�?��nFȗ��z��!sA�;1� �(�q�l�V7��Y�����@�ylU�0� \G�5��Ԕ�S��w�{F�$����w^9�	�u|L����h6��C�P~��EV�o��c�U
�)���pT�4��ptz!�
��b�j�pu#����a�$�<�f���u�+r��wH܄Ё!��
|�qVU�.H�QΕ�t�a��a�+Ȧ=z8Д���߅<�M\���4�1��w �i����H\>��=���.�臣�Ɖ6a�E�k1kLv<�1��9�ܫ��t��X��'|���1�N&�`s�Bz�M �����ê�A>HD@P���?LɧΙ��0�5����V-��Ax�c�d�kdɄd�S;U�C��A��j��>�sn��؇��h�g
�9Ud~WX㯛�Ót&%|�h�Y2Z&�)��Y�8<,�g�k��^�a���kfW'<O���>4���ZG�=��l�(�FstJ/�'6���M�@OƏ�?��S��.�z�Y`�Y��˃�B&���g��z���U�u�93���YDy��8�Ψ��+��p��UXp5{h��0
�l�;d�`93�5w?g-ﾮ���J��� ͘
���91�C&i�"髮l��"8�
�B)`�Mv�fzk��P��"�Z� g
���i��_Z�DU�GEP�'0,|DvE�(���}�q+��'JDd�u�-��-(���S�i�Bq��hc�ha��V@�Ķ[�}А/���-�e��p������t3O_�"�sn�$J's�=J�h'�1��

�#�U��hY(S�q�J����BG���=U���;�czǖ�:=N�9G�:�������'�5�fc��s\j�X�c�}�\������〠p��Ԧi�
"�{i"c�8��ή�.����K(t�$���#��RB������.{:��mp��dkAhw;%�x���`���`(���6��f�?yt��LC��o:�z^۴�CK;g��Ւ�'�}��9K��J	C�]1�Pf�����8K��;��6�IәF0�	��@�X�����S�H9��|��_y��OD��c�YHn�Ǐ9�.�
�(��S��ј0g����aU} �9S�F��FkR�x�<k����� {��2�0�]��պL����͇���z���_�v:H��ilj(���#Wc5����`4I��ϼ�~�S<_�v��% �V�(B�<jy���0���>�/�dx�c.7K�Q�Ӳ�z��zq��7�F�_��`�K�8<��=�IO���A���IR �b�.�	�i��NܗK(ft��
��X�	נ�EQ}ɴK{}���\��M���w8���[2�av]���ax�$x�1��Vc$���FgX����'UogI	�9"�>�J����͙�Rr^����%`��j�����#�� o6��� B���A��2�Q�(�bX�=>[��}hz�����s���/�j<�=d#��9Pش�~�iQu���B�Guf� �4t��K;�N�+U�[��)��|�wu�g���`�;R���X+e����}�ҳ��d(3�Y��(��!�RY���&����_h�j��w���cGw�)�v�� ���s�V�75���u��pa X#���
��<�Mh���@�5�38����y�y�����/�)_/���n"r4��kr-n���:=-Mo�>̂(6�=X8s�4�(�� բdW�������I8�oj�!P�GHN�����8��P��*:�!�*/n���;V�m�l�
�:�����z>��m=g�F���t*���.�l�0���O5
܍��~��A�K������z�LBH�	�^�E��gOv灭t���o� �Q��g^�ys|����DR�,T��`���9a?6|5h��ȉ
j1!�e@��f�h]��`�3��\!^��v-�f:}N\2����m��)�].t����q����a�Y��`���fXA�Z��0�6h���f��������P��8L�q9q�YT��X�6?.�#Jhf�&�in�bQX���cU��g�C~���4�qF�<Lm�q�qh�΢�R0ƾ��q�1��X�������{}d�o'�{b��$z�������DB|�w�o�U�zl�z>볣x��`>�p���������kS�����<祂�x� ��޾��^�_o�6Y���9���f]{�g��do���߫:ouy��M
nI�D�6���U�ێ��,�{tO�|��.F�3�#��|C���@�}f�Gn�.�3_�����}��*�dlpnM�2����죏��%����	��L�;�6"�a\x�]�@!V��a�W�)����	.�	2Nˈ[iW& �Y�Oc�
�4�
1:����Wh�U�=1�� 	s��(���(��(�d�
��j⸞���Ju����6�ñ�	��.<�>��%/��W�m�O����=��.A�4��<)C�9.�Ü��`|�,l��i�J����r��Ͼ�����'�}N��QǑR"�g�^�<U7�]����r����3!ݰO�Ǻ��>QIq�S�ر�fk@%[j��(��nޥ�sK��A�.�#�(� ���6���e�N�!nQhD_�.��?�_��ZFԗ���W�N5��w㍶��x� 
5��|�m�}���ᣚsd�}@�r��IU��+��Y@j��b9�y
�ti?;8_B`�qO��������k���7��w��XNX Q���K�,z1v�����g*lE�9�/��ʮ^z�c�ڻ�	iQ�b��g`�C�sr�f��e�O��v��� &Y�t�2���+Z��d�$��E����:T�iV�r��Ow��j>�<����-���
����/y1��ƿ�m�+�RG�H������I�Fnv���H:q ��n���p�ߪ½�vCsn�b����ֹ�ǝ7F�^ܘ'�R$�S\�$ī��+iS�@���֥�}�`P#%I-�J��IA�� S�Dw@1�N��c�lfor�����\�]�s�A��A�l��0c�Oml��<'#C��B�2-t�K
9gC�V}����D$���;��`l[���E��"�8�P\�l��T��'t!�E�ѠIh#Hcg�{��� ������4�h[n?W#y��p����
;alF�'d/������'���\�as�!+�lC����-e��-�m1cur���2��ܱ��H)�z�[Pg}�.�=�*"�����T v"�[u����XG�W_��֛>�����Lm&�p�)_���U����)gڐ���w7d�y��L�@��%�G��D	�l���L�a�![�����;�
nȀU���L���F���h���bYo��Ah�S���
{d��>���d�    ��|�\�պ�=�ɪ��kt���7C%�s
�%�G���&p<��]�)����9S��Ib6���.R#H�L�|`��H���
����m���wΒe�Rb�=�)M��U����Dx�'~��
�A/�v��Ei��S�G:ӷ�q'��9�#�c��rd�t)s7E���'�S"�He{f<���Ĉ�C�
d���∭�܇�n���~�"#��>�-Z/8饆) ���p��D�M���̖�)�X���qG@$d���Ȧ��h�'���w�J�	aB���A�=졔���|厣�~a�>��}-�V�����o��'�<�96�`!���.�`�j�ʯ
*Bu����o����v89���Ŏ/]����ڭ�G8�}��eG�D���n�ֈ-�<��5+M8�Z�������0�_��p��M	��-q��Ӵ癮�
a���?��������DVp� �S��(�K�U}�����2�^i�}�4lC9{�~P˪q��O���o���8�<O��ew͠�e6>��q0>���h	N��bu\@�dt�
5<cG�כ��"�tMЬ,��{!�=sI v�J��8o\��{�����~���(�_bw{�TO��/r��{f� ��V�����j�"����*mU*z�}�`P��O�{�}V���Γ�`��םb�9n�	�8L�P��h:<���:���iݔ�:�~H����Tz�������:��8��9'|��������o_5�8Ζ
wx��U��s���:#���O8j\-MC��8��9�*+}�&�ȃL��#�P��%=ψ<�z���9݇]+4(����b��o��b����֕wU��a|�ꡄ��Ѐ^*w���І`?�a�uE2��(����v�������sb�;���?�Y=p��O��aG�����}���x��Ϸ���Y�1i���&�u���X�A`!Q�+�x��oZ�1�G���8f��En�O_�~=�Ks��u�?��\��S�z���u�73�L@eW��(�
�n|�vi���W�X�s�`���A:�l&K+ZI,v:Æ��шOjc��2��565�C$�ϲ�E��I��Q�Zz�!ϻ���gқ�R�	޳����{�?�����!�9��D:/�D�o��͗������D�<�'|�7C�짱�I��<,�OHm%&RQ⁗w
�9\!�n�F�u�����d��}��#2���jq�gqͩ�Y��|�5��
���}p�m�W��|�؅�mV��q.p*yǚ����3%a�%6t"f� -���R-��
88<�� ��HÛ<QE�X`���{�-t�ψ亮Oئ~�q1P�f�N�)�Q��J*�s���nHB�� ���\M:����νfk�CU��������
����+    I��LǐS�;3
m�0�p�m�KڣCcL�sSB��a*�Ec�����q<���h�xМ���IwaB��]�\�eW�|����ba>S�U
��]��gq��-bz.���7������׉!�><�%�,�3O��^!��}z8[���N��o��WY]���J#�O�
S���d�ĈJ��v�!��{�`!0�����'���7��6d�bp,qK&�\�Yf��f��WuB)�F��^XQ�����/�zz!,R>�z_�5��b�{���7����9��]�8���6��9�.�N-('�|�15��J�]T
����!>�~�x�|cqQ	c)�����4�p��Q,�JmB�ҁ��BȠ��O[�g6%LA��CJ�m���p�.�p�k�l�DL�ڄ�X5�,� �
�Xk'�g|�Uֲ���O��̇������ײL��D����û|^A�����߈�}|a,d�
���{=%v������){�w��7p�.�j	�~���d����Y^��:�}H=�͢�
�H�?2��L�O��-N����g'�߻'oN___^9!��V�m�����.�T�&��y��w�J��~�$J��q���w?��(z뿹����aWg���{�����m�/j�p:�]�-C�[]:��qU~}��
�RHb��2�Q�s��i��'2�>�'-ܷ�nWcw
���R�y�,ι��m��
!��4�HLW�j�Z�"-�8�$���-NgPոc����b�Ř�/�K��|ңC��S�zo���@�:�n�f�b���܃����F����4����.���r��_v}q1#^�4�1N11�s]��p}�w-@d�f	�=�.ØY��ۼYVt#�?,��k`�G�D<#��VE0a,�����ስ���%�"���%�\�-�E
ް�s�4���{��6D�>�)�����Ϫ�jt@p."��K�P��hV!��0�[�!ߐM����ЊGb|m�RgUV��?<�Hxr�5�K�[
ޙ���:b3�����.of0�r֝���:)Mt���Y�8��p�U������'A���?xQS����]�������{X��:�Y�R��.L��Մ��X���L����6��fu��[5k]�w��8P��w�$�a�pC��e��Q2�zU-oj� T��%���Or|j��/�e�|�����b��=�sO�jC��v�A�>���(5��M��y�H��B}]}�պ��^f���B�J��ژҕl�]*Zկq���=��/�_s��f�Z�z�F�կ>�i��q��c��b7�s�K���o�4/�q�Xa�zNwO<�/a4�X�O_��%\	mh����W҄d��'`i��'�M_�,��y�����>�wo��q�c�j���Մ�nJ����ٟ��ʺȗ��t<BÐ
<�X�)��y��N��o��!��O���}�Z�/�c|��dV����^�PID]��2{�/3]�)uD=�.h��pt��5���>U�bU�Ѳ��bbw�,��3V� ��v�E!�>��(��f��_���T�v�NG�n�g�/�����m�/����:�Ŷ����x�`����L������)v
���Ԃ!M|)���8](5�d��,���\�������c���x�\~��>6O�UdG^h�X�|�^�]�1Z�i��WU4����k�:Il�v�A���4�hGĠ��E�[��vnK����S
w�m"�]�4A���[TC�؅���bN�K�ƈ&��4���J��9�RR}O����9�e�pH&>�A��00m�f�,�w|�2q����[�������2FaA��K�_�J��a��e���5�.�����xuY?B2Ф���nQ��Գ����u
1����HSs�x�\��{�5�z�^��}*��j�7���{��Kҷh���y����a�zL<�XQs�g#� |>t�|���`��.w��cM� w/� ����/�����v�j�q��da��P�����u
�����cE�@��f,��%��7xO�����7����}$Ǝ��S�Ke�R]���8��W"��#c���0�Fwn/vS�u    �p��4�<lQ�PE
k���i|��Ĥ3��7��;H�
��R�Fm��ѓ��e[�Y�u�jXi�#�%��>p�?����!���y쳟kiv�@%�K���_@��8o�Y����,�ۗ�&1�i;�R�(�la�'��(#��F��ϰ��%L\�hb�tâa`?�N��J�h�Hr�?�'��aŐgr��#�D$=�U.�Q�91,��?x��5��0F��;l|�����ܯ)�f]����mL�J���@�:2dE�|6;�2���s6#��b ��M��-"W}���%٘|�P�}a�7�b�)+�j>�{t��H�3��O�z�r3SH��VPo�a��O�R&t�F��C��r�Wx�GsZ��My�hB�d^���@��Pp�
z�{j�Ӣ�6�N�9�y�@�D9PlN7�#^�j����!?���J§��*�<m��M�DTnf��������T P�_�BbM"��O�@O�1��o雺p&d���M(p��Q$�C��*L2�\��p1�?�*!�!�_!� ]=��P��]�1�9L�X�;����pw_���~Uz+��������,1K�</�>`�
"�@��}�@�Q�J_�O��yds��g8*
��
0�ɼ��ICC��&��ޙL���%\��l�'����L�g}A�'w��n{F!����;b�5"���m�,K0�]�3R�v�;����s�'��41彄ךy�[<!?��}�'�V��zOe܇�.�8�t���Is1BYJ� �Y+�"�MP��a��ʲ��w��lI��~���MD�Gia�d�H;�>��Ќu�EK��?�*����%���[��`3sY���,F�3��ЙQYá N�>�"{�E��?����KX�J���dzfІX�K��l�"�
X�L��BL+��ux7~:��f�D��z,y�,� ���~�/��34�#/<0���G����v9��;yՆ��ӄ%�a�J	&}�Li��.��ۦ��$�n�;�<S-ݳ����;����K�R22�j��ugNN�$���n�+�Q��� _��=�;K�s���x�qA`*�łh�Px��;86xp�Gs,�z�b�x&v��x�8~��e��܂?�hX�Ok��Л{��k2aŝ4��ܦ�4��IE~b���d_�hm8F����.�#,<���E>k���/�C��>y�Cw��
�p�!���TE1��A���2���,+[b��áHҌ��'��Pe�,ج(*%���0g�+�����^�׽ʧ���1�!��(�ٗhd[Ur#�Xt},ҳ���g��"IմBX���I|��K�v1�Z��R�.����Ȟ
W�ml�H��V���7
h��)�~���>�N�EUv��q���	��0OWi$�7*�u���v70�CY<X^���v�f�cϹh�H������N�f���C�'��%������Q����mN�֍Ñ�I�-�YD�;���] ^*��crF< �P;BBuj�֦,{iz"[������Hgm5$|(��t�j��l�)�6_n� ����0и��M6��~�Mo���,%��l�z�G�i�9k�ORj�^H���p�غq^��)��5=���%����Gi����H�  �I�>;�ԇ�FЄ�M���|�Z��>]��ys�4IL(�L�6���u�W�Z8n\?:�C��7?&��!�J�ǖ�cUX�6��ID\lv?'�:��l�����h�E    ����\�B���wl߽ �1$��f�8�m�O��%�=Y˞�w�ؤ|W	0��٘�a�b�PwSQ+ٮ#ǒf���V#��}.+q!��
H#�4B���g��1�����D��|�e�يA���C��j��a
���o_qO��ix%t��w���?6|I�YV��0mZ(���A�3pS�H9�������y��L�扟�C��%�A�НD�c3+{9?#I"�HC���>�g�ti,~$��p��'�����9vħ�F�`j,$")Q@��^�M���%6����}����}����0�WX�קolE緻j�L�7����k��nK����Ѭu:�	c�8��pf`� �/ƶE���e��a��P�<��w�E��
W�#��X#L߳
s;ДR&�闷�/o����˽)1�V��A
5��$�:�w����l~lfb�p�5��@��k�#��DU��'�*�@��2M����Eǔ���%I�4�����S������k6��	�h|��U[�8t�1���������h*A�ì�;��i	��C�T��wzLְ��φ	w������u�8Q'��J�@��$�D5�5��=�'	E��|��������\�KҁL�y�ҽnm�v��$!�[1���ei@��Q��i�A�࠷�KlG�/��欗△]M߉�U�%♋-���6�`u f�A0��X
�<#{�F(aY���8�Q�k�H���'6��kn�(�i��𜍦��4���CNH�%����� az&���2MvX,�@]��]^�l�\�8IC�[��:�4�y)/�yS�	Cb�f���mϣb�{=-��.��R���#�i�p.?���5����n}n�3ĺ�X�v ��)��=�e��ڑ���I�1䦑�t�ͽi���o��xt�"�h w�s<�~�͓�2�Ƹb�� 6�q��x��}��5~�m,`�bN��%�I��4c���j���Q-y���ǥd�d��v�:-�@Z4����d�(T�b��u�����o�~*PE1iF�p;���
$��:�K�Vݣ�����!�:^��ﻆ/5`�/�,����9dv��^*t{V���z����ޯڲ`��bc�iw��Jw`��hF3(d�g�:�7{�p� a�H���
�j��?>/�9HS!\��De
3�
��A�{ ���|���辥<�+�"�tM^t�3����rʩ�%���=SN֧L��K�]� ^�}�#h�/�f3	��b-Z��@.��6�0�����9�X�O^���\��c�g�G�
��HH�	%HGص��/%ڣA�LV��YHS�Pi��d����J�nm. �}f��X�ԓ��q���|*�js�p���^g�" �~4�<��M�b1�!��(�ӝ>Qhr�蓜�r%���J���֧�������P+�{O}����W�67?5Q@�,K5�d
M�k��Y=�I��3?9òN�UP����r�=!���?+�?>\�;eW�ٟ\�Rc��p�]���hh�C"3O��L���m^߱No.�Q���	ّ���o�ռH��a�����^q�z�4��D��N��7y��To�?h���@]�����^���yb�ZMҰ�M �""�g�|�@����z���[~��T�y�8o�o���M����/\��#H+�K��jkɾw#���4ˢ@����s���_~{���z��ݨ`��
Y�u��x_�(�C����$�P�3����fjx��fQ�
��]�����_��#���y�G�`����ǌT��iWxވx3Y`W&$�fD�R=�ᚷ�����s2X
r�4�4�=�<>��PM�(�+���q��7��/�A�Qj"_���%�O)V~����E�F�@c�cg6��]�>{�	�D{�<|�:�9���m�r�#g��L�'Ȅ�a}�1�	�ﲨʻR��9I�,*���������
���=�����T�B��3TŃpQ���D�Iَ�]����F�f�7���#�q��{t��g��M��`G2FO��w]�H�J�X~V	��HX���?`Ȧ�^7Rrg�Dǟ>3I�3afAF1��7���g��j�y>�
0Y	lK�FhL���v_���y	��1�m��(JS���
��,kQȾ�=l��!mg}{�L�!Y��Z��PM��:A�O�,�U���^�.��մ�:�};��89�7J5�}dKlUC�����]!�5t�^���)�9��woc���<� �����w�,%F����P`3i����Ô	�HL+ͣ��%2��J��+J�`�}iGR�\�E>�y���)ve
G��t��A��7ynqN�X:���zGfB���O�D�O
t���dNM�3�쌒8­J^T����0<��!���*;&�8�+��k�G�������8�8���d��i(�B�W�MLճ��^���Ť�^���"�e!0���6���eV>����=#�K��=�_�34��i!
��T\A/~.{#�&�9/"��F7�1ޏ����ao��+NS�ђ�I$j�
�`h�u9.��?��I&��,yU:��#<Ѷ�	+��s8|琳9ܚn{J�����*�!��c�|y����ń�:��,aC><H!?Әd�%Ī���Bg4�ٶ�u�'��ܲ�ۏCU�9I>
P�T}[v�c��е4��H���5���I\����TOU����k�l�3��5���r��BG5�e9#��⩅	���ڱ���,e��OdY?���	[��8�����;�f��1W;%��?)��2��Ā-�~����<���7�c����C%����s/��8QҒ��1���b�HR����d��3�G�r�M驦�Kg�\�l�.�:�$����e�r�ȃk%ł���0��M�I2ㄬ��(&�\��� ҖlXb�4�X�IS�J�F��{(�R�$Jk_Fy]�j�=�ҫY���w[��o�?}(�
����!�f�����4�Бg3�Wm!!�z&T�3�Փ�����UC(��t釧�F$ܑ4c��f*��P�������a����,��������|2���Y��|/���4�`�α��f���8�=	1i4E���◫�]v;�#�%O�?�(�D& ��g�P��M�
R|�]�$bP�ܽ�&1�&瓪����6Q؏O�.�OF�Ĩ�@"̚��G�~�8��/#��T�/
O+򭚼*�����E[��	��݈3���5�u���}n1:���g�Ɔ��pf>lM�ͱW,m^X��?a[�I���
�A(ԝ@U���O�_�
�-�TYM�'
<�&������M>��T��4��Z:1	nB��0��;g��j��p���8;�.Jr�f���l?ט�Q��\̋n���L�6ՎX	�~�Q�	 ��h#g���!�J=c:9$l�t"ĺ��(�$���'l��<�,V�-5���ń��g��wc�n������-o�gx��2�C�0_S���F6��l�?ݐ�IN�и�?t���N��ȝ$d�>˷$0��8��w�t���4Hy>��3�&���Z q��a\�a��}\�,���+~]����M<!��l�
z�+���{x
=gd�ڣ���D�5��;R|�ݼ[(H7�YMh�u�i챭3���T���Ws��]�q��R�����K��ꑄmđ��hץb՘��� e�^!5r�4�(O��_޲���<�u��?Մ�ϗ�򜰬�,խ��0
&�|�xM��
�^�Fhg,�߻n�����m=[�xf�=ÈB�y��߲��|϶
4�SV�}�ݣ	Q��]s�?Rx͑&�H����b�q	�����t��,�*��
�_�M7���iED�
�����e�~��lWHBZ��Ʋ���.��"�D���htT���?/�����!�V<�i6L��-3 T��AÈ$Wx �3�>b��?,w,)951,oߓ����q~SVŚL�VS��s���ܙ<˚��ip�wp?��)���5��`�����v�X���FӄI��ͼ�f��eS>/l���r�F��,o�JH:�'
��v>1�UH�1~�-CME�P�y.��K�xg�	;7�F��0�5v:R�=��dep��I
Ɔ!�v��N��rٰ~���t%��n=�s�5Q��x��W-F߃�fJ���`�G��#qN�����=&�?��A��w���\/OhJ�c�X�ۺ-E�q�Ik�b'OH�K"������/M;��o�u^w�W��t�>k[R�OcO0�%��y(�����rfA����a?XbxT��<�o�!%��ڪ?������#�MK,` 3�D�t�*k	����|��� `d���l�U]�d��A��7���#��4c��G��!>-�2��c�	XXF�8�t�ŰTG�6�����˨.%��>�I��eLH�A������H��}�
�����.�N���M��%�����ƨ}dj�V>�$fvȔ�<����h<.d��ݵ?殊�0N=6��:
w��ٕ���b�X�=�[ ,[_B}L΄a4\n�EÊͅ���U�]t/YO�pG��YJֈ̘=�}[�q��~C%�^������-#��vc�B�ˣ)2"X�e�3n[��I�ߺ�xu�K��h����.���0̦��Ai����(+�e��Ǌ~Z^������p�=��J��R��m1��"�����ӵE�Q�q��vKJ��v>���$uX7k��(f��y1m,��Or�Ӣ*X�IB����+�o�s���=?MU��9a4���>�ʻKdL��W�E)���x����з�A��QDo�*;e���傸�{EQ"��ċuP�~"i�V灤�7D"�\ؾ,�۞iLd֙Ek��=ɒ̏p[XԪ1<��2��4<{��ϢH�|jj��kQ�l������@�&���4o���<�8��RM�����ŵ����ǹ���"�    ��O%�	���$��U~�s�/4�B���SY)$4>������!���1*ڿ2���J#�T�Ē��sx���2`h�Q�Jb㜔w�ڪl
$�jjL�k����w,��ך�:�2�-ISsC��[{Ҍ�
Jm��O�����ׂ�����3���ʊ�������lX��^4m�ܵ�����_���������gsi�R����Tx^B;,�5��_�	s��g�b�Иݕ��D������
B��MS�G�����i��Ӑ�����f$��|�۠�
+��p:/j�u�X�g��G�Դ��Ij��,��;Zԓ�\�����M��.+t,�����#6��:Vq����0#s�X��3̒�l?78ڳ�Ql`�b�ǃ���7�#�]3B�.𴔨����wF|d�&�iBlТ�+��:�=��|���\�����ʐ(�c xPql��:�Ⱦ�W��b����%4a��7vG�W ����_ɍ�,����n��`�|x|��CǰLW��)%rm�%^V��{�Æg1
�����Z�C�?!�!����)�$�J�l��#e�J���� O`������?瓾Oq`e�Ї���a8������Y���}Pr���2X����v$ۊh"Z+��"'��o�%�� 9���Lhթɢ>�UB����郙����$�G�;��^N_��̙�N?!�DJ�b��$;��d�Kٯ*���e��k&(^c��>�#Ik`�=H;����;�MH�׏��+6%_T��pmHi��>탬�;���)��k�{uM艡u�cK&b�	�7v$g��2�f�O���O}�֪�i(}�/r�����R�E��i������b���a�`o��96gJ�
+���ZDx����Jnxّ`�BcT?�C��A`=�s�CZ/8ix��Dmfpdy�$c��77�k�2!U���D���1��GJ���o�А���$O+`�C;��ޙ�]bq#�ᐐ� ����A�q�����q|�̟�����0�
٣h2
UIt#�y��%��"���r,2�\��4�#�g����徣��l�GT��#��+.�T�_|�	=I�K6�L:�H�R�h~d2
��������#�"�Rw�̓r8/"���JU
7�����}%���}`D�	VhZ>�����>g~ERe;xj�8�3���1��B�
^Zt���s�#李	=����~!��Q'�ºq3X�`��)4���kyT�G�&���v[vFH��f�4�a#
m
��j�M��R1j$	 �Ś�?��_5��}=�K�b3a=��4&�Y}W��x���]��(���E �r�ʅ�p�� /i����� G�f��y�vn۞����62��1�G±�4�!U�F�e�P�Z
��]�QfH�
�1��t�Y�ȥL^���!��!l��}U����C��}�n���� ��I|\iBP�{��o�^�[w����!��.l>M�M�	(���/�]�3isl�B��N緷�÷y
]�u\����O�><ϡ��h�O]Qo�(3��&
TU:��·r�<�Ei�v�,����
AQ�cyM���b��*�v�ȳ����ۉ�>A���B]�9�L<L�Ws�z����v#l�}a���"�J�M����t�h�j��B؀��#���#u$�.�+xBJ͈?��[�9�!��~��Y�#�5Fݱ�l�+�,������jT!�����1��FpYTIS����$|ˎ|2X��jlgl���ǬU���T��o��
L�خ���,�qYw����(�}����\�J?���8��UI����՜��UӶE7;|_|a}�<���6?vD~���ag�0\�f88�3�q>�%�2�@xˡ�p��[�gQh��!4˰����&����#�G �l��{1;����Of�0)�jʜ�2b^��;�w�y� ܗ���W���W������k%��Xh��]3-7G%����}�R7��I�����Kq��<nl���Sz�x�M2�o�y�
��'[ , ?ԴT��1�QQU�7��s1P�CmL�mC�#U!Li�U�2�)5ݏ����=�>�ߑ%����'�Z�UJ�	�L�;�@����l���q��I5��I`m��r6��\����b4j E�M5�ɛuI���?��Xl��$�0����O���6�M=�}�+h��ݮ����î�e#�`�9/8��	0i�|�dg��p_��y#��?oȃ�# �����Ȓ����7L\��2rh�䆗MxU�ڣ(?f�#���)�Q��N���JY#l��Bh�_��b�#Ɛ���ٸ�0�x;�dcݱE]�؉0h�k�K5D�0𜑰)���n��`�'�#���\�0uΰ���yC��5I)�68Zd_�H����6��h�2������f��ږ��Ҁ�7�k��zJ��G��m9�dZ)�b=2�,Q1_���C��W*�8��p%��E�-���q�.:҄��ˇ?a�(e)��&��`Ѯ��R:3��9'j�ǟ1�c�-4`�I:GU~�O�eZ�΀}C�/84cA��5�冑Njd=c�V������(HCB�$,�`'p�ߔ|�������_����>�d�U!D�}+�%^�#1���[��s���&��d�5f������0��z��S��o�};c.��s�T�N�쏈���{�(ət������I�!����D��&�#�Ŭ����sw4�J1iFzZ'��U�r��$�+�'��lW:��9g��T�|�����������̏L�0;�B�f��F)g�'�e�,�M<d��{,5ƣ
�-�a��dc��� ǁO�#����E����i�I��������dĩU�>8��m�����ҦI��U)�ơ`;��
�I�{�F��"��j("���C&Kf�T�k�����#�H��;(�{�7����P�'����]	D�>�a`���Ę@e�C�2��m��o����ipЈ�?���=�cb[��{�
��K��J�n� �	�M"�Hs��$��\��EI���ͫo} ��p�37)��y�U	KtB���n�/�w�E8��`%�3d�:w;V,�=������cBO�<��3�+��������"��FR���2WvMW�N��y�4��$��K-�m�<ό6g_e�k�t�ɒ��Hɧ��c
a?*mؾnw�J�0��仳!�ٲ�|��oIM:����dF6�Sn��'P-$��'��٦Y�%� %�gL�tm�+Z��4SAo�jxx�|�粀A�F���n��!&k�G`�,4������*3�FR_��w$�%����o)�KV����,1����Bd^M/����(��kA�q�
���41�f`�@g����m����n��5�
�$j�8�XM��!+.���tߧg)���I��j9�G�;,1IXJ���J��	���nZv��}�r����9d�#�<��=�����7��i�\̫�_N�W�T?
��rGM��X���C�6���
���Nm	�ừ
�
�"�<h�Z�	VA�5���}_�)�`�@Ok�O��.�r��3H-/
�bɦ���us8*��e�T�}N�r�1�NDV
~�~^~u�����IW��-�B
����XR�d0&rF�C�� ���7 J��?�RU�Z���v9���f����i:���A*b�&x�8tΙ��l`�Vea�I4��?�xaw�|�&J[3����3&������0�?�����

���O6��y;0[�#]Js��uG0�3ؿ8�h1�W��2*�?&����=��Y7n����?�g4)q�%b4�&K�m�����;�����j�DC"�3���,E��	���)��I}�l�����!{�,ĄL���j�2碩��(�9W��D
LY�Ɇ�}{����f/]L��Ut�uQM������̌���hfp|YL@S��X��bN��w�J�GRJ2UIT�s�j�n�odz"q�8�UU)�8���\����I�y�R����%y���!    ���������c:Ρ6ƟO`
��(r��	�y�^A�v*\2[�j#l8�kg(�e~?��[�|O)��9j뼢�Yk��2��:�3�=ZS���1PЖ�Y�>'N*���An���ҏ�s��Po�N������݇������	4����"���vR<~�w}4X�n�A��ֵ�ys'�*kp��q�_�}��fu��J�T���ĦV)�`R&��۾�燸�猈�yS��*�UI������~8�9�	X7_��:RiȪY!
P�:�mt�=��,�?��o�?���W�pX�t�t�FcΓ�������,g��|�d���W�$=�"i�_vI���&p��%�Ms�������(ۧ����8x(�jRu�p��EC�k[�{u�=�퉡킾����t�C��Q� ��y[wE�Q��3����A!��6���k.��x6�19��A�Cr�����	3����H<�Q�Bo�4:�\����|
�R!�6�]�0�-N��#���F'�|Y�׿�?����!�=�T���Oc�|Ưr���^�[!��*��pݴmY�,���E��~�9�a�w�b�mJ$o�è;�T3qNs���Nج�B� ʚ�\8�搅�v��ݶ�����)���X�^T�k�s�B�|)6
�O�0�[
��-zYv�C����>�B�q���m������Ti���k��;�l
M�"J;z��F!�����PsM���:�Y��Γ�`�a&�A��"6L]av!ΎQ���Ǻp_�y=�����)���Tr�-��
3f{_H��Y���fi0T�?���w�L���8 ���3��f��o}j�E̯��;i�Il�^�l��FnY5�?f�zТ�l�<�X����>}W�<�����v(T��F���)�`�|1ٞ���4��5�7H���"�m��~Ba�����|�`@��~��8t^�Y��n�<�RCp�@u4^߫�c���'���	���
��PH��%�ys1"V�e��H�
��.{M�+<��_/�;��/�
�A��l�W�j� ���յ�֗�ד�ED`�'�f����f��J�)�S<g#=������CCd��	#�Y>I�A���[RB$`ɲ�kc���2��A��8\�1l�y���y�oEU��sK4UrS(�-��xZo�ھ)�}-��B��2L=���2V�M3����͜/����QpS�,�3�J�6\@�E�65�8�a`$(�T?���N�
�gc����Z�7�4�E4��O˺�c�xM������W4����CZ[��5��<�5mX��
QH�b1i��
�+���=[�H@F�"8a��+��l���t�
֦ &n����hh�8�췉�te�G�;%&Iur�)F<�0��@u�8�n#���ƾE���^5������a��ƥ}V~�K�Q���
��Oj+j2/�}��)���+4�{ZNv�[,�D!0&8g�H���օo]f��c�xR�6��A����H��;�1a���G�����+��Ľ��j��仡A
��=}L�(L��9�:{�����CT)�F��� �
l�aԖ�EG��/7͂L��	�;����넑xc�c��	h��8~zY�(�j���l-q��� ',�L!�G�����\"�З|�B:�8f���B9��K��8!��y���l_	kФpX���dG��s�6�}�m��"���f	Y%5�#�=�l�'��I������j1m��}���d�4�IӐ|̢��D�9�ӭ���C	B��*o8�qI0��e�����m&��!ƫ����H�ls��,d�:&j�A)��������T�A��@�4�M,��5yz��cs�"�3��)�h	R񾸝�ߗ�j-&VS2C�i�ai�~��b��{|������&0�����
�g2�)É����!�{���i�rX�́~L2M�sHt�^�^��ւ�=�ĺx�֖��UÌG|͏�,ژ!]���ND��V����	=V&�eX�L�W�v�:YZ�D8	`p	W�O�
�X�J�q��4=�����9K\��B0���$��O���'��v`)�d}T�!61�Jb�_[o�Q^8r����4�`Y9W����Ī풚���vK�������i�������s�*f���y��
j-�
3����g}A~g�t�r�,g��$���w1#��qS7/�/���|^U����"b ['F�
E�i4#�'qQ�s������(?X#�Ϛ�a��f�\55�鮨��\Ty���0�FDVr�p��`	�6nG�=�[og�<�9�����r��o �D��})�A�Sv�#���x��s�c?�����=�_;r�5�D�H8(8�C/AH4�)0�O���&�}%�x>��ϱ��9C`���I�<���wGlB�ad�`����k�h�ߋXn��;���7�#�+��j8L��n!�O���8��$h�1m6���Y�5"���xSH6[ǲV�������D�a�Z���ʒ!Kp�rD�����+�-j����杤�Vc�m�ƀ��E��$��Πa�	f��[;ؘ�=jL�ᇢ�T�����lhK2��y�i��V�۹�@$��U�"���H���k�{�DZ�v�3����G�`Oڎ����h�,n�.�V�{I!�X`�]���7�q�����/��x��D��!T[�	т]����P`���*m3���ηW�eKQ���ؐ�0M�9[$v$ҧ�#��BaEa�ؘD�B�4� �$@�C2Y0��E��I0ػ�#T��-c�rC���%���'�	d+$'6��k9�3W�6���, |�������$�H�<q�"���4J�I �F~����tK����DA@�Y���f�jG`�kH𸠩z����TRg�qh�Fw�V�ݖ��'�m:ػ���{V��g\�!l��"� ���d�Z���x��i��`b�ֽ(�V�WM�p�6�i��Ȏ�����Y�C�������W؃ݍl�%1�S`�Aou�!3���nz���
OG��@FgM��u�aؽ;�te��;4�kL0�<���3�ߐ'b�d��A��ɉ#�G}������'�\����9��S��=�[�wdg	�fÃ��M�˶ZȊ?����I�Mc�Au]6U�0�qz��`�3�/^�%R1gA!����
|�OL�7��b��v ^X���`k׶l�ƕ���E1��&��^~���"4*���G�c���!a"��c�%���s�O�ƾ���V-8ij�x>`gKBq^03˗��7��$���� ������{C�X���P`�d��6��.��]����a<����Tmu�"���L��/�?�ӌe�/�a�9`���?q�R�L�(�j�)���!/v�r)BX�iJ|H��%d����d�b�{WNK�zҖn&����~;�E����>�;X%r5$9��E�r�ʨB���\2,���}"��0,dW��Ҁ�FQ.D=�#׏C¦����ؑ���{��� =��/=�:��h�P�gɖ:�PQ�O�%?��vd�a�̮�N��g�>+��8o�mGr"�P{�%L��af�iB�M$4�6�&�y�=�y#cp�R�<i���YL��
+N*5����d+��G�>�-ڑʾ�y'�rY}��Ya�r����G>�[���t��S�1U�,�$�W��x���r�����;��?ʢ�x�`�)>;f#.}������@���-��m +&*nd4�C���혈��y0�Bx+���"F����t�����������{�8D<������	�Ļ2�y��������$�����9�@�OBs����J����|1�T�澩6��1�tq/}o�rGN�Wd��G��=�QV �<�t��sGT�C���)q6��6�5�}^>M�r��=���}���(h��VO�1%��O��G��⩽ ���en�|��BFq�b#VZ�1xb? ��Q��9�a7�	�6� '��*6f����IN�E*��X�Kp�����˾�5y4�R��0c鎼��e+�u]��}!��2
i6XW���l,��9�NH�H�1��>{��m��?�oL�x�(o��fO�"�>)l�,���mf���6ډ�:nm���X�1�K�o[O
6��hx
� V�	N�S4e���Sbc,!���l'��EVh Χ庴D���&�lW�6�������W��സ1�3}X��`�noO�8������fx/�T�<�{�}�T��gG.�� �M4����e��r��[�^9>[�L��=Z=�x�V�q_��f���հQ��D��5Q��i�å��f�0�*�		�s�����X�J��r7BW���_5:ѱ%�`+�o�5��F,KG��
�?LXC�~���хՙ�
��@�Em�(2��Z���(t�s-
3�G�R�j �c���ҝYu�n+�L�,<�.;uVmj�$U�ɥ_l��;��QM��d$>�>��m%1�zGh69����	��d�dh̾��&~�J�tg�*d�����$V�1���2��!��@�F0q�a8�a�$��@�e֤ADilۖ�8DԄDG���~Ɯi��=Q�K�D�3X�'*��?�U�������g��0��S�d�ʱ���&��D�Y�i6 6 ���1��E={rqgkb�
�� ��h��b��Vq�SCl>�q����g�'�s=X�7�oy����������N�,���1Gq��gd����a���x&�a$(����3Q%u��kIz�����4���l{!}
^�(6�6E+lC�����S7��a�`�&��a���
�!OQ	|̛���ha��12Nz&u,�:�����ēz{�#�fwK���!"Oj4�G�'7ְ��2E�k��yT��t>��e1�+�t�蓬�A]�%-����t��Ďh�����ykO
�B�؆��;T�%��?�j0|�G�6�F+��T���%K ��z��{�U^�Xǡ~��r�@�M���G�\�ؗgS(���ݱb/}��əj�Lr�a�<r*4�L'K�t@.�:&���돥i�����O��_^f\�W�1�f�RǴ�v1:��R*���<-GG��}j���㑛����=���!d��޽�����YKi��}e�c(���=)�$��&k�����;�cw��؃��L:6@^c�-N�8������M�,�T�+���
z/��#�k�b�U�Օ��*L(��>=`OҊk�����	O�	L*2���*�l�|-|�b�l
�l`)��m&=�x�_4�_�\�����v��'�|�DF�sĻ��x�^�+��X�k{�zE�1�5��<,��wV��L�i��/��9D�1Z��"+�g���u}u�_l�
��ȓ�6��5)n	����l��N����$6C�!��iSy_�J䆽����w����r`��F�o��ç0^�i^v�hI�8o~��{��D�deso":�uM��Θ���:~�!�L�0��$�SQh��-Q��A�٩9)���	�|���c���}�h�o�����?��<�iʃ}3�>B����|����9�Ӗ �.E~P��
rI�)(�u[N����q=�f��LL�{f�"���tV;)�Y����q��e�4�!���#^ܖ�g�md��#ika�������D`1	v�Z�"Ǚ�E3�\��fL�AZ��G�!�Q?���"���[��0R��>���J�N�b���I�:��zW~�@08
O!��$�J��mUv��k)�����#i�q������]�    h'`o���p���B_���T{҅ǚ��E:�e�ox��>9����yNK|��roT��x����vc>�w��pJŤ�0�ыyg���⧾�G\V>VD�3Y����-x��ؾ��Rp��&F��/٧{���y��w|o���)4U�
�:�>��lE(�p�j�'-7hp��܌L�$�؏t��'� >�)"����ν1"�-+����p�(�c�$>Ί�JPL����A΂��^D��vL�yR����(�卭���L*p,��њ�s.u�f�bC�ax��:T�k�����N0˱��>��$���2Q�/���&]���,P�y�
����IbP�^(�CGF>�7��h�P)R��U��o[A������?̞���&�>4ߥ���tw�0�����ۮ4f���K`PfB���@���g��s1i�K�I;i2L�m_��ی���=�����L$y,���Y�)K�D�^���&ݘN&��MJk��w\ 7��=%����(T�`U}��x��ma���� ��b�ʪ.����+�nh�����w1y	:˂Ԏ���-a���)X�d��`�:,ى�'}U��yEʵH��/S��Ѣ��lOhq7�e�V}��{坨H 9!2�`�2�E���2�Ժb��}���C�J�to֗5i�ꓢZV6ɥ
M��` 
��	;l��"E�ծf�c�)��C���VƤ!RL��Kɐj����!�=o2Dh����,O���챪�=H&���y9I�Fue:+�X�FA����vWm�X��Mw��(���JLJ�Y,�c�ĵ�tEk���gE�RIbT�3�:��H�:����l�(dHQ`4M�H�es|(����eBh�@�&�}��w�fl��Ʀ�F�:&06��<�O��T�H�ݱ0U;yI!
tCxǤHR*�Ā}�+;H���0���dK�,a�י|1�W2%R��mf��GVY<@��L��*!L"#Ft5[b}j xɃkL���G좂Utit:����W,���=*"�y��u���O4�CL���}ʚ9��#If��_������>�M���Τc����d_�eO�����ߤh��.�h��N#w[ӽ�Rƿ}M�:c~�!�JUg���n�G�HX��7A`Vhm����3V���b ��/*}sQ�V�����f�՛�:k6�p\��̀=�tVD� ���NOK�	`�D,F�_v��?���W�
���-�'F���S$2W)/	��%4��#\�s.��(
��^��Q�[:6�!��0w��\�9{��n�W����t���I��4�]��/��#JF�$&��H���m�.��0DSW<t����1�[D�����1�2�+!�����]GX
�-��DjbC8a�5�{c�e�d�bi�|G<�
]��j�IbK���H@��~e%�MP���EV�Kg��5�Ai�,��b�
��w,���8�u:�Z��Ţk��L�N���q3�Xp	�e��T��m��2��"J���A'�û�4���E$� �g:cEN��@~5B	�c��k��
?�Mp����g�C~���$j37ʤ�>JB)�}Ԑ%�7ۈ!?p}Vy�	�5YYҮ:b��?�̐dv0���&��(������]6)iU��E>[�$J�<)��uR@��aq�b=�}�Г+1��bdL��Â�ϖ���#YnKt��R��5����f��&�
��_�L�62}�����I`f�`�O���`�sg�0��-]o�.Ӧ��ѥ�[Q�㙬�C^�uJ�sĖ�\�W�0�Ľ��=b]�f�a����� ��I�6vH[��	��]]� �d�9����m.��?�;1�CV���ml&�ہ-]WD��]�+a�g��5)��v��N�s����֓�+���Md�)�v�˴ә<�3���Fy,�4��$��x�nR�ڧ�p:�m_�&�G�| Gy�їO�Ow��;1�.�bx��g��$F��$8�ۊ�Yڐ׽}�� v�8����8�.3`�gF 2�E�����7(�	^������(�庺�㗮o�V��2�C��
��գTೱ|��s	�<3�d�1D�IC3톺���B�8
#GEFeS�C�����ڲaM�;����J�e!����e�B��I^?�/�_ڊK����ヽ��
�&#
�I�/x-N�l���(4CpgZӨ��x���΍x_t��h��Ċ��!�>o0�g���r�(a)x�#L��I�~��W�ʄ%��a��#�K��i2�+�v$�B�YS}�rcN�T\�[�վlP����=�޺����|��J5�����}<N8G?�jl1Ih�81�ݛ�/��j.�оWY�(6_�2e𘁾q��.q�3�ee�t�
-˞�3�@�u��
B�5��t_�g�"�qy�q�2���K��
#U=� ���&��*�OU�*��3kN�M�0�=9,�Y��߱�c��#{�G$�aD���;��l9n�O�onяop@�/�N�>�"I�l�n��\��m��
+�a���
XJe��O���j���v�����pB��F^n�D��45u�_�#B��t�M�����Ф�,[��+����h�m�����C�����k&Mw�f�:�^9�� M(E뎇]4 ���m�ԓ��8�Y߂��
�G��&� ���X@K������ +ᣋ��
��V�[�V�-Y�v�j�L�W=ć���SU�E��]Î�VCK�D.�Rqh>�(�O��9I
?%��i�l8C$&֋�z1������"�N	&0�1n�Q֬�$���2<�T��B�=�ʺ��/�;�O�w�g�y7)l��þ�E&�T��ð�{�F�2���"�
��:���i�֍�����$��V��q���	3;K@}ɤ$���馀���#}�
F=>�������̵�u�=)y�6�a���Ww(=�A`�� ����ɬ+,���a���U4��	o���O&]#�G+�\5��ח��$}ԕ�]s����:hE	�/&;J�t6�[�Wa�Yr�-;Ƴ���g����
+��<{���Us`{�R� nf��`� �/5"��:�}�>�E�c{	Z���f��K�r�gUQ<�ܔ��qP:q��,�j�����\�o�k�������v�q�A�I����]�,߯5�5�(�����6��8��4�;���d��>I-6l�ۈ�A&�9�^i
K�n��[�<+k�=�U�d��|��c۳���yKd���3�H�&%���	:�OD��+��[������?��$�����k�SY������4p�D1����4�G�v�i6��y1.��_R��٩$�'r�`��7��<����~�AK�h
��eE�}�r�/�Y����I�ߣ
v�f��mw$�|e�]66_�m�[KZzka<K���f\�q���8�#7%m
�~�oƄ�w�_��tI�I������WD�:ӊ�HR;M�7WE;g=|M�����y��B��쪽�����-Kq,c������]�c>���^N�i^���H��n�gl�wӼL�5}�����>��7O���gv:��7�����[��D�����fM⿼Il����BGnd�'�`���A{���@,�yV�j3��0�����P�5,���{��b~����pOO��#D�%1��A�݁��u2��tJ�]r�-�U����bM�C���xno��:Mu��ZBX?lwA�W!���V�����1z�p"V�%I�c=�$wj/V�T>��˔!�v���+���
d���p�V+���"��-G_�6�	�*�|a��<�(t�aC�?H-X.wyz
��(d� ˧��{�c'��
G8�`I��j����U�#�%��u�B���L�V��u~[�/7k,�"Q�X�\�
GG0Lq�Ѓ�t�o�3��
���i��|���_np^�a�ȶV�&m���ɬ��ʔ���`����ÒM6ط4� >��2�7Ʒ.��e'�G����i���1�Z�@��V!�5C����Q,|:M3{�򟰟��4�a��NZV�b��ؔ 0�T��၃K�'���Y���m���I-_P��%ƚ��g�WZe�� B[
���&݀����'����v����Z�8���4R߁�}s�@��t<��yJ��9e���H/	,V�Z���`k��1X@�d��ŏ;XOa�ʋ�/o�8g��goL�+1f��j
�೸�dVI<�'�:��	^�}YAG���&VrĦ�������g	"�_�ƑA���np�<�iӜP�,��$��@֐4��IYa���<zG��tTf`�����=� K�<7)Uq���%JW�;$6Pz� o���\���H�0�~f0="�KL;�賅��d���d-S{8G�$b��c/��Ҿ@%���7cG��*6�    ���>�~P�kp}a���)q�X�
�`4׺�&��ֻ��s̰�{����x�<ų[�	�2��~�Y�_�m������'�`����D�I�
Mґ����]) ڮ��r)(�4���jkx��D�d�18���<�����M��2���<�%6�P�'SY'9�٨�g��!GcX����8����ъ�l��l��no4�ػ'1<��;�K�"c��+��#z�"D�b��!�	mߟ���>��RӺ%����Y��11A�~:����cA��D�����uY�i�%�˖�b��5;bQ�� *�`c��(��b���!�
��j�ub�_�lK6yp�?$>�I��k���
o2�[�/2�e;���(w�b�\u|�.~�.���E�dȤ��	ar���FX+wI�ؓ���IL�M�u�P��W+[ T�n�g�GQ�)��Cΰ]��"z�Q܆�>��[Jz��ih좏?/��:ē-]�P����'�
>�X<K�
q�<ߥEV�8�}�e�u��F]-���_��Y��Ϫ�u���&�����ͤf5�?f�ǎ/O�,H0�Ch�d㚍���mpT�+;��&J=$jS�yr�!s $O	�;���Y/?�^1}��q�Z�|5�#���dm�?շ���D�h��6��E��y�C��i��,�8$fz_�����sV<M�M!Ӹ��;L��7z�O���Z��.����,$���y 63L|�&�����a�#$��2p�ċqH��O:O>��U�����շ�>	��_	ű���Sa
I�qB�v�qu���c���u]�c��� L��<��Gr����;�@�}���KL`��v���V�uZ����|�����w*"[+}m�_k�P�Z�2���iH���Q��~qK�D�����ɰd�Ф�Á�~ݖ%'$F� O�-�9)��xD�ƫh�WR�2ΤX^�%~'���␝�ʉ�H̘�=��q�Na� ��������Y>߬7'0��U����G�É毣(rLB���%L�OO��`���g��S��l&w�Ϗ�
f�J<��3��c�\|&h�Q�{�׃���%����22?"ߒ���,���^�)����&e��]*���^B}� �ޤ��s�6P���'���X$�I�b�(��輍ɺ�?p�B=%�*1�nPܢa�=
d�'�-�7�'���੖�
�?QM��K�/)@���3��%"�w��g�R���h����I�"�/���I��?3��s��.EVא��$��(�{b�s;��,����M*e5[R��/�OE&%.x2�O,ΘU��}xGl�mqQ�����Q����j�To����!&/^dR>���Io�<�A�g$-3�w5<W5�襺bG`Ȓe�O��@�.%��·Q�,�f�p��gOT#��̘��
�;7'$vI���0yʺl�f���i�˚d���1�����\�����'k��:��l�+0p����A�=�q�EN*�}��~
R����[�M�Є\P�5Z �k�Pɳ��J#�w���>+�lt�N��I%�����x���>���#�G���Z�W9�ˢ" ��eb)̆��?��f���V&)W� ��){]YC�oΪ��),ڭ9��f�^9�O�D3���]Ø��=5�ϼ7��뺛��%�k�N���%U	[<��)1�w�+_H��j]s��[
�رu�.�?�������}��|�r�`Y5�[ݡ��An�KG���{c�֥�g���(ض����!CB�#TϺh�}���H�ӳ�[����<�𨛔 ��׾ݢ�33��t�������uŏ�^z��_�1�����^>u�ihM%�(�N�^�w9�Y��XF�9�Ic��t��QM�5/����z8�4wBF�����'�_X����a���э��%&a-���K�ĩ艌x�BV���Dd�9R�'M�@��ʢ��E��
MN���Th�ot�}W���N��ۄ&���w29��q�P��������	읧�����.�KU�_>�햾��Q�8`=������i�Ui�xɯ(=����<0�iZ�&�١��`�S���
c)�{^d��FR[����9Gx�`��&�PH�~8���a����jp�K��8!�5��p4,m�&B��Q}4aO��D�@o���M[�b]��0�8�G���� ��q�L2�<��~���Ky\5�����V�c6�����m}/�έٹ$�H�6Ȣ�'*�1�;˚� ��s������k�\�A:�=��u����uY�4F$,���j��b/�s2��o�붙����Ɠ3�N�'ϵ>��+��:t0O#�g�3�����ө0>o�]�τI ���b�V��B⹳����x�L�5��YZT-��v�������:�cZ�^�+��C��Dz����k��)e:��W%TY�(z��y�p<L��{�ǃ������6B���O��!��H�.��nG(G��Ĩ���U�P~7l�e3�F��� �f�-.�n��۔��Q�L���zw�8j��D�D��8��Nˑ��Y���ط-=$ul�q+#�b��0�T�m9n�0��^Ǥ;��dϑ�������][KT��6�
�R��-?!i�'���NCmđ82�'�����%�7�_�j[1!�h�xv��"�km:웶$��eU��E�-8aH.��g��dU8���%/q�Œ~��}ڗl�<f᳼�ݯ!T��Wf�T�QV�3v^���fv�����X\h]��ٜ�/�c%��_{�D�Z��2�#��-q,����bϨ��K�?f)��Mw?�H�#�U�NM�g�~͵qI+c��y.�r���x	C����Ҕ'۳�e# �mb����F������%���1�������l�Ӭn'�p���㈴�&
��MZ��f�yJ�I>��u���#Dh��U�������!X���v�ƬD�"�+��%Қ|���R(��|���5}fe����T�(,��i!>d'~{+�|7�M�!r������l��m98����t��6���b�Z���&\6�8������RF�!�E�O�g��G�^��w̙��u+$-54���d�g�qa��.�_Td�η�$-�G�������g/��d�
Z��}�������7�m�����Z	����a��F+Q�q�~x�I�M^#/2�m#���f�$o�4Ó(�ȁ��Ň'!{�cr1���Tj�ˣ���8��.�7���m�3�EiH�g6��X�1~0ڄD�5�V���"7�C��>�8��wY�<̧ٗ�	��M%�By��b��;2=�D�%fU�$p�\�t���3L�;�B&�7�`�mn_���N;�����G��$�L�5i��MZ�R�c�����aDF%���M*��Y��T��ݖh7��^f�������}v�k��h#�y_�L�W+[�{vez�u�ЦQb��n��z�Nں'��)7�(4q^[��2Ǝ�cgN.�tx���d 
��=3���Q�N*�aJю8�
���8	�M���ii����Ŀ�4�<&kM4�0|�ŀ4_�� "��4;��˙Yޯ��bA
&��    ��#?V>K�Z�zY��	c�"ɞ��9!�G��b��ǀҺ��I;�X�z�6��TEִu�_�ӕ>����"�
���M.��9�����.)�2��_�ʳ�2]�٪D�>f<c�Q��o$ϙ7�|��=O�0a��4�$Ǔ_��M4wq��>�M~�c�����&�G���7��L�s���1õ�b����~m_VUY����E2�ղ��kwq��vw�~��﬙UDfN\Β$��	��5s3<ey�^�e�	�;�ae��X��/t���G�"���	�gG�W��넰8y6!��}o���_��}�&,��M�a��t&�b����<��\�cFFE�|��z�p�rj�7�"�7�
i��� �f8���:�U��ǲя��h������T	2g���H�H�����
����!��Yf�k�W�����s��@yί��������PB�������i�.���QLla)�d;����d��;I�QG60���g�_�����E�5�і�������,c`!�\E����1�Qy�VѸ�%�o����?��4��/�(K{�e���+�����(�C�]W�@�$��{��\q���'�/f�2�i4�؂{�X���4�lGJ�@���3��d��ߓ�X]��0E,h��ƿ��M?���t��=:C�KV�0��=��عF~�дE; 8$(�/�Z
�U<X��7d`�@��4t1?��p���[D��}ƴ��=Z���
��(�U�D�ۏ�̓Y�h��mo�+4�kJH8z"ߞZ<�����w\�q��Sځ�#'������^xmw�Bp���6.�秫 ���eO������[2hf'+���PV�l����x7N��V���2i��cγD�!��F�
�/���[�MELQkSp-
�B��G���h\^Z�z����Ao���S���^�I�4�˶X�!#��/�p��c���eu���ݻ=U8G���W<6:"�k��,����Wr@)T:0�^���/_�G9_ΰ��)�dAC��GW���[�����OK��(��q���B��I���@DG��k�-~S@���@a��kMO��OㆷQbjk�R�{]}�H|�dw�1ܳ�������~�F�(\~�sX���{)��z�����G]*`W�B����aS���P���mU���P�Fl����8�k��zRm��0,������5mhX��?s��X���|2)�G�]�����L�k��E
ʯXH��2+��Kz[g�ɣ-����䋳jJx.�o�MS��s���C�5�1#��V���
m�j��%����|q���hsO��jf��[�E˟�lmZ	��j���w�t֑j�,��r}���R��w�/�h��~��=vڛ7U]W��^`�u}\��8��u��o��>�)!5-Y�mb�r
;.�O��ԡ�i���7��az^��x�>W�%c:�q��ݱz��Mvf�12q"��?y� ���|�]���5[��:s���Y7)�~�a㰤J���k��c1	H
6`�*�}���TEe�+�@t%�@� �GL�)���'��ӵ`�R�!��Ft�C�W�%�.ne�3��d�ʕ�ք9�<�d#��a���YE?����L��-�q�W�#ۗ
]\��7f��f|���HC����@�AI�d��Ą51��uM��`�t E�9.�$����?|����t��������`���a�T�%�$�Ur�3�"�]K#���:�O�V��-+�E��Bj�a�?|��[b"�,]��@Q:l���I^-��!����̨"i�PD0�8슦ּ tY���;^<Z��u\��'����HJS-0i�A��ɶ���7��M �aU�}�'���J1A"��2��DSC�Y��
5Kf�zs|v�<?:vQ�GI    ���/��E<,$���&6G�JUB��O�N���4c���X����a04ן��!Y�}!��?l&!&qs/Ƽ۝#�ͱ+ֈ�֚r���B)���m->s˚�/�w+�C��|�PN��Ԟl݋��Q���璡�3B�������c�Gpc��� �l�s!X�Ȯ�/������#�5t����R���Y�ƴ!������.�i��3�Ё}��f�<�k���=ty�CD:3B�y�XϾx�|ȟ'��3�����O8j®�~H�u�w?/�e/�9�D��I��K8�/�������HýZ��0ny���b�p�a�0b��#ݕ 6���]'����s1�^�W^��(r}�o�c�	O���k�?=̖��z�W�K����O��#]@���a}&�h���ڞ<L�7����|ԧ'��W�Γ�%�ϻ��;����C�7�z0E;x��d:\HP�۝ăQ��%	�T�Y;|;px�&��d1aW��P&������㢑:�(�,"d���ر�I�m_�u�e�3At�@��Lɻl�_�_��������tn�^������2��֛��w�b���x0��,U��X��ʗb}�T[aK��bq�3S�eJ���%�El�}܊���i�m��M�a
��$evL�AO�����>��<q^=�^��G<��T��2�#L������dP�7_I�k���j��U0`�J_�`��?���㱠�WB�8a?�O
�,ڕ��F��ن�s�
\��C$���D��z��l,Ӂ����:�9�ܘ�&��r
�˔��K5�*����n
�3�h�` ;��o�K�o;���WA���$;�9�	�n��N*&#�ع}>mS,�p5I��njs3g�ZL����'����.2V�0���<���a9m��"��Ÿ*�_�y��F�}"n���p���0t듄��������io���V��0��D�o5�J���2SA�]�9����4���#�c�����5�&�F�e�}�
�b.!~m�<[;3��S)=����g�#��)��J���S? ���鑶�'vxGpL���EV���7�K�M�?�0���������U+FI���yE�����vp��܈&E$�x��o���2��n$V�~0-�%3��x6I�a���`7�O2�kSW��oI�֐02D_|��hGp`�/;��Q.�9bj|��I���9m%j��t{��2��7m*�z�u��#��oE�R��ؗc&�4�"d�Tyn]:X9\���ؾ�Ă>�`�U�)f�?OR�
�F6��P�Dݕ�R���W�]Q��8[b�r�Z�X�� ��C��KY�e[~w�'��ӣ�yxG3�bU�d�3��	��β�y��\ 1C �v��ض�0���a��$��=21z�/�lΘ%�E��
z���&������j=�i�.	��)͋�\q!���G����+ͅ^;����Z�z��s"�E�,���T_]Y�<�r�4O�r��+�Q�kq�巂g�1�*m�!6]�<���FEpG��X�,�O+��/�䈻���_2^��W�!����z8�p-�G���i�۾k�Ű{�
t����s�f+�^� �Xl?�]f��g����B��*�zr���� Zg���_2|��ݘKP�IV���dc�����Ԯ�׀.|D�`�3��=�˃P|o��Y%J11�#2Nj]x�?�]v��4����C���s�TM��|���b�?rV?HTmEn�����z��ڕ�"�y�L1�2U����,O��R8��H��y��;烯M��_�#u�{o�H�Hh�����G�79�)���wl^#O�J�}�7e]�)��e��7�U��]��/�|L���LД�`A1m4s�L��ΞM<[�߱���qH	;i����v�������e��@��;��X0��H�չ�"��q�U>���Y>f���doQ�����O�uFh��W�r��24?���ٳ��PX7�#�����n�ċ1���\@��(���g�s�=ߐ^��ٞ�;��J��֢�)$n.њ�E��X���@�oo��x�Y��
6c�������]�Ѹ -"q�KvA1<��mG����b��ǂ�w/�w��Ɲ��*��?�u�� 4	˺���C�{l�����J�����B�AQ�^B��rv���Ɗ��]I�L�	�"˂Ii���l5�I[�]��1Ya�&��7m���M
���	e[�>�fir�t/=!6�F����{�mc4+X����/��>�l3�i}k��dВ�����7�PXy�z��CD��l���hLp��9gQ@tRA��7�+�e�4o��Tǀl��p�4����'	}�3Iu��i�ӭ���l���#��ؼ���,�W���I`�V.M�74���%��4�6#�5l��2�O�o��7�z�r���Q;aT��B̔���;66�s�}`��׵s��4���:|f�B?�ə�"\��ac�	BK81\[�ш���\-�U�D5b��v��KXyb>xA������]2!�BM�ݳ�p��9d������=��\ʴ�)$��V쥐^�v���C�[캰l�C#��:��E]	�A����"���듢[Y�ߝm,%6E�3Vq=O�{$ȋh�Cz\m�t��8>%1�3��Dv�Mu�ܧ�5
a.u�u��K��;�a^=?�xa�#fZ^��W��m�tp$!a�	���╴T�E�Ҫ��V������5M�iFdv���ʚ��HP��rݺq?]V�<o;'�GYLV��e��lO����򽤕|"���@a���M����'�/{{�z��۷�FI�Pgǎ�I�;���_,�끯���˄�ƴnA'͆����4��(�49]ٰ�
q6ųm��j=лc��z<h�Ԕ�c�b�&��F[[q��M��H/�Y��FEh���z��T�^	��P<��<��7�@!]w
�ܗ���U�L��|<6Y�S%ď��yf[q�:ɣ0�j�o�kWl��l����]	�iZ�1-��ۿ��MҬ���Q{�q!��A��]�4qZ$VYշ�+�O���LPǈ�H�P���y�,���)�a���0�|b4� L8Ƈ�6�W���7���%C��Uu��K�8��:O���<a�I�}e���o�.<��?A����N�^z1�d��/�|(��O����{#�xO,�QҊtW����!�Т��Pݐ�9bCV]?=�::�x���dX�mOH$#�ye+M����3�:l�_�/�Z���z�l�8��� �Q �N�[��4���׊eA���ӂ�2�4�Pb���-'�ۙ��6�E_�CXC�/,L�r+���Ӻ\U����Y���)92	�GZ`eWzWXl�=H�ju6��F��̖}�QHj0i�Q��d3�yC�^�W����
�4�H��zzl��xK��CC^�E2`�z����{�&=P��f,��2��EI�4�tw�&E�d!le�[O0aY�ry4�&��!X�rM#a�`>1�
�JWS���F-���I��wD��x�,`���eU�O�B��}m7ڔ������;�*+���	)�	�6Q�_�i2>},ɋ7*�z��t��y!i?#۲<e���`}o^����"H>��e�+�7Ρ^S�Ȥ�]a�ci�rJ��$4��K������q+�rȑ��Q��w%�*d��%�,+��
s�����;�}�',��6�NX.K/}_���B%�f���G-��ˈ�s�N�H�4�����L�u����φ2�j�t�v�+�\�p��XP��Rc�Ȍn����J���=+Y�~�(�9P���:F��8'ԉ)�R�a������ܠ2#��r�8
t���P'�a9Y������x_<>��"N��5�;H�,m%�4.)YֺB#�M��G)�)_v�ÐB{��rQ炒�H�;�R!�Ө�c���uE�d�
��ŌX��E��9l3k���
ϖ8&Y���@�u7�iY?˾�.,r��b�k����q9����6��M��O`y�f����؃˂��j3ŝX�$�O��4�5�.ItA�7HQ�`_�{���
!/1���s�^Gd����}�Ed�Y�o�!}�1�-��N�X��!�F���F�wa��«���Q�kh؁2'.��x3�s�zti�d���ݝ��B��N
��ܤE
��q��}���Jr,�L}�U�u%����b7�_}O�M���w �v�y���l&���1M��e��9C���i��b�+'&+�B5]SW���>Si���cK?���z��g���U�bҟǞ�Z۷���N��Q≸J�$;��q�<5`HG�g��>]�ʰ��&���!�6Hl�k�p����g�ޤ,��1����@ǸIVL���9%�k��R7�	`I�J���L�xS��Ą�ݗ�A;���JM�㘈�{_^ Vm(E�R|2lN�5O��b�?'�6��	3�!-X�>�Iʅ�69�ظ�3I�EM�z��{��
&>ћ�ȇi�:6�g\&e���׋d��5�B�D��Y��E�F#j௵cj�:#��0����4i���W��&	�|i�}z"���O�5��j��pa�G^�Z`�gF���D-����>/ftM�-�^�(������W�ʁ2?Č��!j��di\9q(G��xC��b��y�N̆�
ߥx���,����ܖ&B��_��`�t/&G��h;Mʺ*�y�E���ບ	up���
?K&��=�4=A�U�K��})7ǧ�R_����pU�r��ɓ�7F�u懿���r34� �|�昨N�Ƿ�|H�;Ns64S�'4bZ�>�˯�lR4���o�8َZ��I5��Y�ˁYp��W�Q�I���k�;�{F�B��~�i�3nk��&��N�/`eb.$����Xclk�d�0�׸Y�q��FIRb>���z���p-���Pձjz�$v�e`ޤA*�!h���ʤ5���٤Lwm��n���\�e��m�w    [��<��US~�r�0hb�
��5
��m�����EH: ��Wl���ͮ#�@:"w�L(�Z��\q�È��:�c'��0:w����$�0"?�b%�]O2\�lpe�T���<9zW��`}��8��?�r�"'�u�C�� x���'G��L;��y�G�ҟhTG>�8��I����SwB����H�|�M^�`��D:�Ub]I�q��N�
���4���p�5Z���1��$�j9ɾA����Io�$��Qų?�$%�x����lx_|��?$�}�Fr���L ���|�U�T�gKr"�$�8)�m��UƟl;jI�|��va�}Rx�x���}�
8���\�,��B�b"�4�;�M0	��x�	DAw6���v��;��2�|�E�|iڂ��Z-���2÷
�^!�<AQ�N^#����H�p��3��^v�����Ԡep%��A��n���$.�I�#�lb��RdOK������P���a��iEZƐ�{���`s~3pa;��ӵ��Q]�G���7�����[u�.}̪���H&��i��O��ѡF��bjW�R�)�D>����X�e�	a`�ƶ�5ߝ��� �
��#b�h�)�l(��`�>+�}�Z�m���g���E
�ӄ�a�-w5DEp�pa+N�y�N�9֞Kx>a.�8!\͕X������<O�09c�<e?\��h�\�1��w}>��� ��ڃ=�T�\4#6�$5��>gm^Ҵ�*����Hɳ�v����^����Gf3_��YY�;���5p1\�Rz�w�2��R�}�ҼY���<X��q��0$fȴ ���4��и"7�Uy��8t�lq=l���܈=e!Qg
�6Yuw���@wzEࡿ��z
3��<��'	���_�c��^��w�'��O��h=��qYL�D��2<�q8�����F��b1-^����]OP`�V�S[N�_���������Z$j'ꈫaO�$
͋�[����(�:*�]�m������vV�gG���);
�Y�v��i>�'��]�K�f���{Xhm\��ʗ�Oj��7�����vR�6L=���]^3���z�[b��d5
N$)�G����ճu�:�:��0��	c!��蓃R�sbHѸhpsh�}a��������P��[X�Sl	C���5�B,eЧ#�nO�࠲�o���A���2�)��N��
���l��w��3"�lL𵧟CR�Q��+��86]�����12g�ߊ�y�86}��y^s:b!}Z~+~��O���$l8ãH����1�7�$L��0����@�ޏ��:��e�U[�xo
�6!}�G�Lm�\�&���B*f�kݓ-�2%������-H1�7���Ċ��B�yr��B�A�'q���9Q��IQ�ӃxO���@��6�U��
z������P�C�U�(����:9�t�3:��TOd��q<5Ϥ�pG��D�dfJ��'+4^��lRq=�{�/���p	��#-2nj�H1"��@I��d��"�H�
��u=�1yϟa��� ����:4����7Tλc�0��͛a�x![<���#�6cE�y�It��BGd�&܂:=��H|$K�n+v�����sdKIV`j8�}�V�N�GX���K���m|kݍ�0��^�$�MY�����k��c��މCQ%��B$U��1�\�Q��:�N�p���,�7�����p a�1¤�����@��K%�D�]��+�WL\�|wd/z��էl��;G&�la�N| �������M��GR1��cx4��	7�,��s��d���XJ##�&�& ̎xB<���kqp���`�%<u藑9Z��Xbd�,:܋,½��\g�n���sP,��*R��1G! "��N+k�n�r�S�7��[��V�|Rf_a�ۄ��8���a͓��N����Nѕ
{��s�=��e�,_xq>�M�݊F�Y�aK�b�d�[����.�v�=��UY� �W��W�a@ b��Y��s|��iY��޳̈́:�`���l�JХ�p��zx/`^J����i�eȧ'�7�r2Ӫ) �L <Xo���"`��a8;�f���q
����yR/�[k|R(���:�H�2����|�2	pݤ��*6"<}��^�;��W� K:p]���8�Ǥ\��Sg���DƸ�X-?~���Ang��(��2e�Om��_[$��m�aj�yz[���jЃ᰹|J�H/1h<?i!f'��E&�͐�g͗�m{�oi���?ҳ�SV��-?�[@u�J�ߞ��8    �c2����b~WWD\��f�ɷ���Ŗ�u��AG�u"8��=��!�`��4K��ƆhĬ$k��b�
D�\bl�'{�@<��M��J�yd��_��$��W�����'��d����2=�J�E3$&��_3y���Ԣ0�d�"���a�[ǘc!/���|a����u�]�=y���MRV�]��˝U	�~��dz%R�Z�7Jl���R°h�rሲ��a����8I&�m���h�}�*&��(�t��T�ʆ���� ���:�(P��mb�B�k�'�) mJ���5R�̷%<?R��!�F�0k��B�g@n�RQ��}��_ee5�:�a=�'��GC�/(P��~�����]O��l���u^�p��U�˔τzE��CX컶�!v������2�����1+$L��(������M��kD,�٬�������&`~�vH�J*����h{!N�纞�C���d�MVy��O�G��`��
,�+���H�2-��y�.˶%y+{��g�9�H1��^��JZ�+lN��خǻ:�۶W�E��2�>P���CY2��%B��ɪ�:� �\uQBW��Zo�|����Pķ�X=ɬ"]6�@',�~z��4Y04�F��
�J2�|�0®�����'�����YV.Wkf�'��)�m!˞����ChJ��౨w���L(6L�~h)k
{���r��ǫ�г��hc�:��<��K[s="@<�/�z��o36 ��|��`p����jf݋��J2�|&�(��M��G7�a
�HF�}�C��wi�X�Է����kq�@��B��SY}W6�)�6�?������v
.��ni���M=[l�xH�ŒXE��@�Olh��օ����9����G�`?]wQ`~����ר�"HÈu��vEEhI�ٗl�Ad�����j��m�������5|,--�mA����8�!�J�9�c7�'�`s��j'Q�;�c˖����z,�N
QB�Iۢq�c
��0���=�泏�_/a�IK�a<��Ya�D!C��n�q�6\t����^����p�!3yd+�{cDAN�[�̾3y��9a"KG�¹1�3>�xk�b�V�	��g$X��$T_��D�IN����&M��̰�OBD�{f[��R�'+�{C7	��x({���9���b0�88�m�л1�����R��x��`;�����Nv5��0�c4�PlZld_
��Y�)Mꯃ��+�+/�-I���S�L��w	Y�[���
�M�0J��-���AC4�H�B�)��k�aRM����J������?��o��{�F ��8�g5�/{0�,@��M���0�:�*d�cm�4D�}*,�K�Q;:M�<v�S����O��fD>�d�r�؏�w�'�5Xr��2($�S�Y�+���0ۥ'�����G�It-�mS��h��nx��*��[����'0h�7��o�b�?�؎�#6ė�aW�8lD�}^��6�Ɋ脤lo]6,*�����j�PYjѓ?���\�D%�Lv�+-�n�0��d�{y���X���*��f�UV����P�,)U� �s�x��Ӣ�>�K�(e�m�S���]l}�M=��C�M��URq)�������zƨ?0QZ���=��ܜ�_�ۺ����  1�\����4G�b�*A2�b�d ��PY�֛�O�h�g
	9N(�Hg��e���=�I���+��!����
PÕte��a>�-gd/���[U����8����û�nU�6^����H��q��dw֪���me�lw;�)ߥ��x6�͟�'gW4a�X�`����Y�`Gm��@X�|�u�Q��J�mU��Y-pGvY�
%J'+���<��{�A;�/��������W˲���
fofY[�?E
����P�Z����&��
�x�ٻz,�ј7��q�����tV���ĎH�쑙ϲ�S=�,����{�6�y�*{��rBW�\d;1-��`nA(O֫���O������uC%KjW&~��\��e���E���m
V��t�5���h~L�	��ub��էU��ڍp5O3L3A�p��	ћo������^�l��G�n6{�r�!��%�n�S��@2zN�����n�w�ݖ�UY�a��B����;8`1��@�W�>2X�ʐ�`9�d}G�����grM�A\GMzۛ@,��4��]�E�3�N(n�/]d���
�0�~�6'��ȡ�nh&W�x꽑�\�n+S����DH�~�йL��lT�����Ζ��4�W��g��3B��[C;0 ���n�`^������<��ݖ����d�c2}L�?7��="����Ì;˪1A=��ҞHm�+{�Òn�q	�%�MȌ�^&?=�
��e��׺U�+~z@�!!��ȵt��	x����D�#]NX��`W?=�ĻM;�V23&}ڲm'i�>Fl�����4�xLcE	��=b�p�4[���y��bv���O�\XM���(fa�� b��x�u�4G����{����'���K��@��4P�!��B�+�pW���Z�;����%�J�~����d�B������cn���&`����W�7�=�j��pжp7��������o��,�R�ݑƿ�2� �i��i���ʂ�E��g7+	��;|�c6o��\�wt
��|
����"�b��$�(ڐ͛��?,�M`�oJ��"]����B�ޔ`R�fDVfTeY�7[u�ުf��P�3�_����7#O�|�tXgF|�i[�)n�rAR0XB-����M��
�[�L1OR�^�4_��b�%���Y�
�ր��YQ��z���K����emd7�6Ok�3�f�F?�'����I
z%ұ�<�O��n���P$���
��l��ܻQ�sc߽����!�v�v��� ��]w��L0ju�7����jҬ9[=��|�?�c�b61ve�Zo���(�҈Eű�Y����'36F鸘�t�=�mVo��mdA����6�`U0�M�G/T����ن�������x����/���`y�32�R�	*��,X[>����R6��d�-��]}OQX*\>hDҡ�򌏏�)ФM$�y=ߗ��%�9$a��4�'�7�O �p���	���R�2�8me�Ps��&�܉L�u�5��ߊ�,��xV+翗�%F�\g����&���N�	]qY",���������g�{��l����q��:+{�ߥ3��ݙyО�zqc85J���������c�z���������c�>�?vY'"k�.YC&�gk~��d�..I�SMq�Ny��i�s
G�C �҈��+z1h�.e�2g��H���{SA:�?&Z˲X�<��މ�"�W���Ϳ�e��}[�p�+\T��1���P���z��4����h�)�R�`��j����1_L
�=�l�k4��ڼ
6i�*��l^{��6�)���3d(��GtI�ȶ��]1N����I���K��0{�C�L��8,�އOŜ?x���������.Y���}����,c���>i�d!��t�d�9ϗZ��O,�d�����M�F���^wb�B�x�2�
� !|����������r��{0x||<^���x\���r<��/�Cr������l:��O���㲸M�+;�(�%L���v�����{�hrg�X��9�*rl'G�>%ݍ'ƫ�6O��}������#�ܹil�G��ǳn����8:���K�;?���;���X��9﫣�������?��O�?籯      