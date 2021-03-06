
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Система = Новый СистемнаяИнформация;
	
	Продукт 		= Метаданные.Синоним;
	НомерРелиза 	= бит_ОбщегоНазначения.МетаданныеВерсия();
	ВерсияПлатформы = Система.ВерсияПриложения;
	Отправитель 	= Пользователи.ТекущийПользователь();
	
	Если ОбщегоНазначения.ИнформационнаяБазаФайловая() Тогда
		Режим = НСтр("ru = 'Режим: Файловая'");
	Иначе	
		Режим = НСтр("ru = 'Режим: Серверная'");
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	УправлениеВидимостью();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Далее(Команда)

	ОчиститьСообщения();
	УспешныйВвод = Истина;
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Информация Тогда
		
		Если Не ЗначениеЗаполнено(РегистрационныйНомер) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен регистрационный номер БИТ.ФИНАНС!'"), , "РегистрационныйНомер");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Организация) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено название организации, на которую зарегистрирована программа!'"),, "Организация");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Продукт) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнено название продукта!'"),, "Продукт");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(НомерРелиза) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен номер релиза!'"),, "НомерРелиза");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ВерсияПлатформы) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнена версия платформы!'"),, "ВерсияПлатформы");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(Отправитель) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен Отправитель!'"),, "Отправитель");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ПочтаОтправителя) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен Email отправителя!'"),, "ПочтаОтправителя");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если УспешныйВвод Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Обращение;
		КонецЕсли;
		
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Обращение Тогда
		Если Не ЗначениеЗаполнено(ТемаОбращения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнена тема обращения!'"),, "ТемаОбращения");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если Не ЗначениеЗаполнено(ТекстОбращения) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru='Не заполнен текст обращения!'"),, "ТекстОбращения");
			УспешныйВвод = Ложь;
		КонецЕсли;
		Если УспешныйВвод Тогда
			Элементы.Страницы.ТекущаяСтраница = Элементы.Отправка;
			СформироватьТекстКОтправке();
		КонецЕсли;
	КонецЕсли;
	УправлениеВидимостью();
	
КонецПроцедуры

&НаКлиенте
Процедура Назад(Команда)

	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Обращение Тогда
		Элементы.Страницы.ТекущаяСтраница = Элементы.Информация;
	Иначе
		Элементы.Страницы.ТекущаяСтраница = Элементы.Обращение;
	КонецЕсли;
	УправлениеВидимостью();

КонецПроцедуры

&НаКлиенте
Процедура Отправить(Команда)
	
	Если Не ЗначениеЗаполнено(УчетнаяЗаписьЭП) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(НСтр("ru ='Не выбрана учетная запись электронной почты для отправки письма'"),, "УчетнаяЗаписьЭП");
		Возврат;
	КонецЕсли;
	
	Результат = ВыполнитьОтправкуСервер();
	Если Результат = "" Тогда
		ПоказатьОповещениеПользователя(НСтр("ru ='Письмо отправлено!'"),,,БиблиотекаКартинок.Информация32);
	Иначе
		ПоказатьПредупреждение(Неопределено, Результат);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайл(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения(
		"ПрикрепитьФайлРасширениеПодключено",
		ЭтотОбъект);
	
	ОбщегоНазначенияКлиент.ПроверитьРасширениеРаботыСФайламиПодключено(ОписаниеОповещения);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайлРасширениеПодключено(Результат, ДополнительныеПараметры) Экспорт 
	
	АдресВременногоХранилищаФайла = "";
	ПолноеИмяФайла = "";
	НачатьПомещениеФайла(
		Новый ОписаниеОповещения("ПрикрепитьФайлЗавершение", ЭтотОбъект, Новый Структура("АдресВременногоХранилищаФайла, ПолноеИмяФайла", АдресВременногоХранилищаФайла, ПолноеИмяФайла)), 
		АдресВременногоХранилищаФайла,
		ПолноеИмяФайла,
		Истина,
		УникальныйИдентификатор);
	
КонецПроцедуры

&НаКлиенте
Процедура ПрикрепитьФайлЗавершение(Результат, Адрес, ПолноеИмяФайла, ДополнительныеПараметры) Экспорт
    
    Если Не Результат Тогда
        Возврат;
    КонецЕсли;
    
    Размер = РазмерФайлаВоВременномХранилище(Адрес);
    
    ИмяФайлаИнфо = ОбщегоНазначенияКлиентСервер.РазложитьПолноеИмяФайла(ПолноеИмяФайла);
    
    ВложенияСтрока = Вложения.Добавить();
    ВложенияСтрока.Ссылка = Неопределено;
    ВложенияСтрока.Представление = ИмяФайлаИнфо.Имя;
    ВложенияСтрока.ИмяФайла = ИмяФайлаИнфо.ИмяБезРасширения;
    ВложенияСтрока.ИмяФайлаНаДиске = ПолноеИмяФайла;
    
    ВложенияСтрока.ИндексКартинки = ПолучитьИндексПиктограммыФайла(ИмяФайлаИнфо.Расширение);
    
    ВложенияСтрока.Размер = Размер;
    ВложенияСтрока.РазмерПредставление = РазмерСтрокой(Размер);
    ВложенияСтрока.Адрес = Адрес;
    
    ОтобразитьКоличествоФайлов();

КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УправлениеВидимостью()
	
	Если Элементы.Страницы.ТекущаяСтраница = Элементы.Информация Тогда
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.КомандыИнформация;
		Элементы.ИнформацияДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Обращение Тогда
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.КомандыОбращение;
		Элементы.ОбращениеДалее.КнопкаПоУмолчанию = Истина;
	ИначеЕсли Элементы.Страницы.ТекущаяСтраница = Элементы.Отправка Тогда
		Элементы.СтраницыПодвал.ТекущаяСтраница = Элементы.КомандыОтправка;
		Элементы.Отправить.КнопкаПоУмолчанию = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СформироватьТекстКОтправке()

	ИтоговыйТекст = "";
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Регистрационный номер: '") + РегистрационныйНомер + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Компания: '") + Организация + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Город/регион: '") + Местоположение + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Продукт: '") + Продукт + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Номер релиза: '") + НомерРелиза + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Версия платформы: '") + ВерсияПлатформы + Символы.ПС;
	ИтоговыйТекст = ИтоговыйТекст + Режим + Символы.ПС;
	
	Если ЗначениеЗаполнено(ТипСубд) Тогда
		ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Тип СУБД: '") + ТипСубд + Символы.ПС;
	КонецЕсли; 
	Если ЗначениеЗаполнено(ВерсияСубд) Тогда
		ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Версия СУБД: '") + ВерсияСубд + Символы.ПС;
	КонецЕсли; 

	ИтоговыйТекст = ИтоговыйТекст 
					+ НСтр("ru = 'Контактные данные: '") 
					+ Отправитель 
					+ НСтр("ru = ', ответ прошу прислать на адрес: '")
					+ ПочтаОтправителя + Символы.ПС;
					
	ИтоговыйТекст = ИтоговыйТекст + Символы.ПС;
	
	ИтоговыйТекст = ИтоговыйТекст + НСтр("ru = 'Добрый день!'") + Символы.ПС;
	
	ИтоговыйТекст = ИтоговыйТекст + ТекстОбращения + Символы.ПС;
					
КонецПроцедуры

&НаКлиенте
Функция РазмерСтрокой(Размер)
	
	Если Размер = 0 Тогда
		Возврат "-";
	ИначеЕсли Размер < 1024 * 10 Тогда // < 10 Кб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Кб'"),
			Формат(Макс(1, Окр(Размер / 1024, 1, 1)), "ЧГ=0"));
	ИначеЕсли Размер < 1024 * 1024 Тогда // < 1 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Кб'"),
			Формат(Цел(Размер / 1024), "ЧГ=0"));
	ИначеЕсли Размер < 1024 * 1024 * 10 Тогда // < 10 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Мб'"),
			Формат(Окр(Размер / 1024 / 1024, 1, 1), "ЧГ=0"));
	Иначе // >= 10 Мб
		Возврат СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 Мб'"),
			Формат(Цел(Размер / 1024 / 1024), "ЧГ=0"));
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Функция ПолучитьИндексПиктограммыФайла(Знач РасширениеФайла)
	
	Если ТипЗнч(РасширениеФайла) <> Тип("Строка")
	 ИЛИ ПустаяСтрока(РасширениеФайла) Тогда
		
		Возврат 0;
	КонецЕсли;
	
	РасширениеФайла = ОбщегоНазначенияКлиентСервер.РасширениеБезТочки(РасширениеФайла);
	
	Расширение = "." + НРег(РасширениеФайла) + ";";
	
	Если СтрНайти(".dt;.1cd;.cf;.cfu;", Расширение) <> 0 Тогда
		Возврат 6; // Файлы 1С.
		
	ИначеЕсли Расширение = ".mxl;" Тогда
		Возврат 8; // Табличный Файл.
		
	ИначеЕсли СтрНайти(".txt;.log;.ini;", Расширение) <> 0 Тогда
		Возврат 10; // Текстовый Файл.
		
	ИначеЕсли Расширение = ".epf;" Тогда
		Возврат 12; // Внешние обработки.
		
	ИначеЕсли СтрНайти(".ico;.wmf;.emf;",Расширение) <> 0 Тогда
		Возврат 14; // Картинки.
		
	ИначеЕсли СтрНайти(".htm;.html;.url;.mht;.mhtml;",Расширение) <> 0 Тогда
		Возврат 16; // HTML.
		
	ИначеЕсли СтрНайти(".doc;.dot;.rtf;",Расширение) <> 0 Тогда
		Возврат 18; // Файл Microsoft Word.
		
	ИначеЕсли СтрНайти(".xls;.xlw;",Расширение) <> 0 Тогда
		Возврат 20; // Файл Microsoft Excel.
		
	ИначеЕсли СтрНайти(".ppt;.pps;",Расширение) <> 0 Тогда
		Возврат 22; // Файл Microsoft PowerPoint.
		
	ИначеЕсли СтрНайти(".vsd;",Расширение) <> 0 Тогда
		Возврат 24; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mpp;",Расширение) <> 0 Тогда
		Возврат 26; // Файл Microsoft Visio.
		
	ИначеЕсли СтрНайти(".mdb;.adp;.mda;.mde;.ade;",Расширение) <> 0 Тогда
		Возврат 28; // База данных Microsoft Access.
		
	ИначеЕсли СтрНайти(".xml;",Расширение) <> 0 Тогда
		Возврат 30; // xml.
		
	ИначеЕсли СтрНайти(".msg;",Расширение) <> 0 Тогда
		Возврат 32; // Письмо электронной почты.
		
	ИначеЕсли СтрНайти(".zip;.rar;.arj;.cab;.lzh;.ace;",Расширение) <> 0 Тогда
		Возврат 34; // Архивы.
		
	ИначеЕсли СтрНайти(".exe;.com;.bat;.cmd;",Расширение) <> 0 Тогда
		Возврат 36; // Исполняемые файлы.
		
	ИначеЕсли СтрНайти(".grs;",Расширение) <> 0 Тогда
		Возврат 38; // Графическая схема.
		
	ИначеЕсли СтрНайти(".geo;",Расширение) <> 0 Тогда
		Возврат 40; // Географическая схема.
		
	ИначеЕсли СтрНайти(".jpg;.jpeg;.jp2;.jpe;",Расширение) <> 0 Тогда
		Возврат 42; // jpg.
		
	ИначеЕсли СтрНайти(".bmp;.dib;",Расширение) <> 0 Тогда
		Возврат 44; // bmp.
		
	ИначеЕсли СтрНайти(".tif;.tiff;",Расширение) <> 0 Тогда
		Возврат 46; // tif.
		
	ИначеЕсли СтрНайти(".gif;",Расширение) <> 0 Тогда
		Возврат 48; // gif.
		
	ИначеЕсли СтрНайти(".png;",Расширение) <> 0 Тогда
		Возврат 50; // png.
		
	ИначеЕсли СтрНайти(".pdf;",Расширение) <> 0 Тогда
		Возврат 52; // pdf.
		
	ИначеЕсли СтрНайти(".odt;",Расширение) <> 0 Тогда
		Возврат 54; // Open Office writer.
		
	ИначеЕсли СтрНайти(".odf;",Расширение) <> 0 Тогда
		Возврат 56; // Open Office math.
		
	ИначеЕсли СтрНайти(".odp;",Расширение) <> 0 Тогда
		Возврат 58; // Open Office Impress.
		
	ИначеЕсли СтрНайти(".odg;",Расширение) <> 0 Тогда
		Возврат 60; // Open Office draw.
		
	ИначеЕсли СтрНайти(".ods;",Расширение) <> 0 Тогда
		Возврат 62; // Open Office calc.
		
	ИначеЕсли СтрНайти(".mp3;",Расширение) <> 0 Тогда
		Возврат 64;
		
	ИначеЕсли СтрНайти(".erf;",Расширение) <> 0 Тогда
		Возврат 66; // Внешние отчеты.
		
	ИначеЕсли СтрНайти(".docx;",Расширение) <> 0 Тогда
		Возврат 68; // Файл Microsoft Word docx.
		
	ИначеЕсли СтрНайти(".xlsx;",Расширение) <> 0 Тогда
		Возврат 70; // Файл Microsoft Excel xlsx.
		
	ИначеЕсли СтрНайти(".pptx;",Расширение) <> 0 Тогда
		Возврат 72; // Файл Microsoft PowerPoint pptx.
		
	ИначеЕсли СтрНайти(".p7s;",Расширение) <> 0 Тогда
		Возврат 74; // Файл подписи.
		
	ИначеЕсли СтрНайти(".p7m;",Расширение) <> 0 Тогда
		Возврат 76; // зашифрованное сообщение.
	Иначе
		Возврат 4;
	КонецЕсли;
	
КонецФункции

#Область ОтправкаПисьма

&НаКлиенте
Процедура ОтобразитьКоличествоФайлов()
	
	Если Вложения.Количество() > 0 Тогда
		Элементы.ВложенияПредставление.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Прикрепленные файлы (%1)'"),
			Вложения.Количество());
	Иначе
		Элементы.ВложенияПредставление.Заголовок = НСтр("ru = 'Прикрепленные файлы'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Функция РазмерФайлаВоВременномХранилище(АдресВременногоХранилищаФайла)
	
	Попытка
		Данные = ПолучитьИзВременногоХранилища(АдресВременногоХранилищаФайла);
	Исключение
		Возврат 0;
	КонецПопытки;
	Если ТипЗнч(Данные) <> Тип("ДвоичныеДанные") Тогда
		Возврат 0;
	КонецЕсли;
	
	Возврат Данные.Размер();
	
КонецФункции

&НаСервере
Функция ВыполнитьОтправкуСервер()
	
	Попытка
		ИдентификаторПисьма = ВыполнитьОтправкуПисьма();
	Исключение
		Возврат КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
	КонецПопытки;

	Возврат "";
	
КонецФункции

&НаСервере
Функция ВыполнитьОтправкуПисьма()
	
	ПараметрыПисьма = Новый Структура;

	Адресаты = Новый Массив;
	Адресаты.Добавить(Новый Структура("Адрес,Представление", "kazna@1cbit.ru", "kazna@1cbit.ru"));
	ПараметрыПисьма.Вставить("Кому", Адресаты);
	ПараметрыПисьма.Вставить("Тема", ТемаОбращения);
	ПараметрыПисьма.Вставить("Тело", ИтоговыйТекст);
	ПараметрыПисьма.Вставить("Кодировка", КодировкаТекста.UTF8);
	ПараметрыПисьма.Вставить("ТипТекста", Перечисления.ТипыТекстовЭлектронныхПисем.ПростойТекст);
	
	СоответствиеВложения = Новый Соответствие;
	Для Каждого Вложение Из Вложения Цикл
		СоответствиеВложения.Вставить(Вложение.Представление, ПолучитьИзВременногоХранилища(Вложение.Адрес));
	КонецЦикла;
		
	ПараметрыПисьма.Вставить("Вложения", СоответствиеВложения);
	
	Возврат РаботаСПочтовымиСообщениями.ОтправитьПочтовоеСообщение(УчетнаяЗаписьЭП, ПараметрыПисьма,Неопределено);
	
КонецФункции

#КонецОбласти

#КонецОбласти