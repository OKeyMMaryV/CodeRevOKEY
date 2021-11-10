﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

// Подготавливает необходимые данные для формирования пакета ЭД.
// Используется для быстрого обмена файлами (через файл, 1С:Бизнес-сеть).
//
// Параметры:
//  Параметры - Структура - параметры для заполнения документа;
//  АдресХранилища - Строка - адрес хранилища в котором находятся подготовленные данные.
//
Процедура ПодготовитьДанныеДляЗаполненияДокументов(Параметры, АдресХранилища) Экспорт
	
	ТаблицаЭД = Новый ТаблицаЗначений;
	ТаблицаЭД.Колонки.Добавить("ПолноеИмяФайла");
	ТаблицаЭД.Колонки.Добавить("НаименованиеФайла");
	ТаблицаЭД.Колонки.Добавить("НаправлениеЭД");
	ТаблицаЭД.Колонки.Добавить("Контрагент");
	ТаблицаЭД.Колонки.Добавить("УникальныйИдентификатор");
	ТаблицаЭД.Колонки.Добавить("ВладелецЭД");
	ТаблицаЭД.Колонки.Добавить("АдресХранилища");
	ТаблицаЭД.Колонки.Добавить("ДвоичныеДанныеПакета");
	ТаблицаЭД.Колонки.Добавить("ПолноеИмяДопФайла");
	ТаблицаЭД.Колонки.Добавить("ИдентификаторДопФайла");
	
	// Дополнительные свойства для 1С:Бизнес-сеть.
	ТаблицаЭД.Колонки.Добавить("ВидЭД");
	ТаблицаЭД.Колонки.Добавить("Сумма");
	ТаблицаЭД.Колонки.Добавить("АдресХранилищаПредставления");
	ТаблицаЭД.Колонки.Добавить("ДвоичныеДанныеПредставления");
	
	МассивСсылокНаОбъект = Параметры.МассивСсылокНаОбъект;
	
	НастройкиОбъектов = Новый Соответствие;
	Для Каждого СсылкаНаОбъект Из МассивСсылокНаОбъект Цикл
		НастройкиОбмена = ОбменСКонтрагентамиСлужебный.ЗаполнитьПараметрыЭДПоИсточнику(СсылкаНаОбъект,,, Истина);
		
		ИД = Неопределено;
		
		ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(НастройкиОбмена.Организация, "Организация", ИД);
		НастройкиОбмена.Вставить("ИдентификаторОрганизации", ИД);
		
		ОбменСКонтрагентамиПереопределяемый.ПолучитьИДКонтрагента(НастройкиОбмена.Контрагент, "Контрагент", ИД);
		НастройкиОбмена.Вставить("ИдентификаторКонтрагента", ИД);
		
		НастройкиОбмена.Вставить("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.БыстрыйОбмен);
		НастройкиОбмена.Вставить("МаршрутПодписания", Справочники.МаршрутыПодписания.ОднойДоступнойПодписью);
		НастройкиОбмена.Вставить("СоглашениеЭД", "");
		НастройкиОбмена.Вставить("Формировать", Истина);
		НастройкиОбмена.Вставить("ЭтоУПД"     , Ложь);
		НастройкиОбмена.Вставить("ИспользоватьУПД", Ложь);
		НастройкиОбмена.Вставить("ИспользоватьУКД", Ложь);
		НастройкиОбмена.Вставить("Подписывать",     Ложь);
		
		ВерсияФормата = ОбменСКонтрагентамиСлужебный.АктуальнаяВерсияФорматаЭД(НастройкиОбмена.ВидЭД);
		НастройкиОбмена.Вставить("ВерсияФормата", ВерсияФормата);
		
		ТаблицаФорматов = ОбменСКонтрагентамиСлужебный.ФорматыЭлектронныхДокументов();
		СведенияОФормате = ТаблицаФорматов.НайтиСтроки(
			Новый Структура("ВидЭлектронногоДокумента, ИдентификаторФормата", НастройкиОбмена.ВидЭД, ВерсияФормата));
				
		Если СведенияОФормате.Количество() > 0 Тогда
			НастройкиОбмена.ЭтоУПД = СведенияОФормате[0].ВозможноИспользованиеУПД;
		КонецЕсли;
		
		НастройкиОбъектов.Вставить(СсылкаНаОбъект, НастройкиОбмена);
		Если НастройкиОбмена.ВидЭД = Перечисления.ВидыЭД.АктИсполнитель
			ИЛИ НастройкиОбмена.ВидЭД = Перечисления.ВидыЭД.АктЗаказчик Тогда
			НастройкиОбмена.Вставить("ВерсияРегламентаЭДО", Перечисления.ВерсииРегламентаОбмена1С.Версия20);
		КонецЕсли;
	КонецЦикла;
	
	МассивСтруктурОбмена = ОбменСКонтрагентамиСлужебный.СформироватьXMLФайлыДокументов(
		МассивСсылокНаОбъект, НастройкиОбъектов);
	
	Для Каждого СтруктураОбмена Из МассивСтруктурОбмена Цикл
		ПолноеИмяФайла = СтруктураОбмена.ПолноеИмяФайла;
		Если НЕ ЗначениеЗаполнено(ПолноеИмяФайла) Тогда
			Продолжить;
		КонецЕсли;
		
		НоваяСтрока = ТаблицаЭД.Добавить();
		НоваяСтрока.ПолноеИмяФайла = ПолноеИмяФайла;
		СтруктураОбмена.Свойство("ПолноеИмяДопФайла", НоваяСтрока.ПолноеИмяДопФайла);
		СтруктураОбмена.Свойство("ИдентификаторДопФайла", НоваяСтрока.ИдентификаторДопФайла);
		
		Если СтруктураОбмена.СтруктураЭД.ДокументыОснования.Количество() <> 1 Тогда
			ВызватьИсключение НСтр("ru = 'Ошибка формирования XML-файла'");
		КонецЕсли;
		
		СтруктураОбмена.СтруктураЭД.Вставить("ДокументОснование", СтруктураОбмена.СтруктураЭД.ДокументыОснования[0]);
		СтруктураОбмена.СтруктураЭД.Вставить("ИдентификаторОрганизации", "");
		СтруктураОбмена.СтруктураЭД.Вставить("ИдентификаторКонтрагента", "");
		
		НаименованиеФайла = БыстрыйОбменИмяСохраняемогоФайла(СтруктураОбмена.СтруктураЭД.ДокументОснование);
		НаименованиеФайла = СтроковыеФункции.СтрокаЛатиницей(НаименованиеФайла);
		
		НоваяСтрока.НаименованиеФайла = НаименованиеФайла;
		НоваяСтрока.НаправлениеЭД = СтруктураОбмена.СтруктураЭД.НаправлениеЭД;
		НоваяСтрока.Контрагент = СтруктураОбмена.СтруктураЭД.Контрагент;
		
		Если ТипЗнч(СтруктураОбмена.СтруктураЭД.ДокументОснование) = Тип("Структура") Тогда
			// Бизнес-сеть.
			НоваяСтрока.УникальныйИдентификатор = СтруктураОбмена.СтруктураЭД.ДокументОснование.Идентификатор;
			НоваяСтрока.ВладелецЭД = СтруктураОбмена.СтруктураЭД.ДокументОснование;
		Иначе
			НоваяСтрока.УникальныйИдентификатор = СтруктураОбмена.СтруктураЭД.ДокументОснование.УникальныйИдентификатор();
			НоваяСтрока.ВладелецЭД = СтруктураОбмена.СтруктураЭД.ДокументОснование;
		КонецЕсли; 
		СтруктураОбмена.Вставить("ДвоичныеДанныеПредставления");
		
		НоваяСтрока.ДвоичныеДанныеПакета = СформироватьДвоичныеДанныеПакета(СтруктураОбмена);
		
		// Дополнительные свойства для 1С:Бизнес-сеть.
		Если ЗначениеЗаполнено(СтруктураОбмена.ДвоичныеДанныеПредставления) Тогда
			НоваяСтрока.ДвоичныеДанныеПредставления = СтруктураОбмена.ДвоичныеДанныеПредставления;
		КонецЕсли;
		НоваяСтрока.ВидЭД = СтруктураОбмена.ВидЭД;
		СтруктураОбмена.СтруктураЭД.Свойство("СуммаДокумента", НоваяСтрока.Сумма);
		
	КонецЦикла;
	
	Если ЗначениеЗаполнено(ТаблицаЭД) Тогда
		ПоместитьВоВременноеХранилище(ТаблицаЭД, АдресХранилища);
	Иначе
		АдресХранилища = "";
	КонецЕсли;
	
КонецПроцедуры

// Формирует присоединенный файл XML электронного документа.
// Используется для быстрого обмена (через файл, 1C:Бизнес-сеть.
//
// Параметры:
//  СтруктураОбмена - Структура - данные для формирования файла пакета.
//
// Возвращаемое значение:
//  ДвоичныеДанные - данные сформированного файла пакета.
//
Функция СформироватьДвоичныеДанныеПакета(СтруктураОбмена) Экспорт
	
	СтруктураОбмена.СтруктураЭД.Вставить("СпособОбменаЭД", Перечисления.СпособыОбменаЭД.БыстрыйОбмен);
	
	Ошибки = Неопределено; // служебная переменная для хранения списка возникших ошибок
	АдресХранилища = Неопределено;
	
	АдресКаталога = ЭлектронноеВзаимодействиеСлужебный.РабочийКаталог("send", Новый УникальныйИдентификатор);
	Если СтруктураОбмена.ВидЭД = Перечисления.ВидыЭД.КаталогТоваров
		Или СтруктураОбмена.ВидЭД = Перечисления.ВидыЭД.ПрайсЛист Тогда
		НаименованиеФайла = СтруктураОбмена.Наименование;
	Иначе
		НаименованиеФайла = БыстрыйОбменИмяСохраняемогоФайла(СтруктураОбмена.СтруктураЭД.ДокументОснование);
	КонецЕсли;
	НаименованиеФайла = СтроковыеФункции.СтрокаЛатиницей(НаименованиеФайла);
	
	КопироватьФайл(СтруктураОбмена.ПолноеИмяФайла, АдресКаталога + НаименованиеФайла + ".xml");
	
	СтруктураФайловЭД = Новый Структура;
	СтруктураФайловЭД.Вставить("ГлавныйФайл", НаименованиеФайла + ".xml");
	СтруктураФайловЭД.Вставить("ФайлДляПросмотра", НаименованиеФайла + ".pdf");
	
	ПутьКДопФайлу = "";
	Если СтруктураОбмена.Свойство("ПолноеИмяДопФайла", ПутьКДопФайлу) И ЗначениеЗаполнено(ПутьКДопФайлу) Тогда
		ИмяДопФайла = Строка(СтруктураОбмена.ИдентификаторДопФайла);
		КопироватьФайл(ПутьКДопФайлу, АдресКаталога + ИмяДопФайла + ".xml");
		СтруктураФайловЭД.Вставить("ДополнительныйФайл", ИмяДопФайла + ".xml");
	КонецЕсли;
	
	Если СтруктураОбмена.Свойство("Картинки") И ЗначениеЗаполнено(СтруктураОбмена.Картинки) Тогда
		ПутьКДопФайлу = ПолучитьИмяВременногоФайла();
		ДвоичныеДанныеФайла = ПолучитьИзВременногоХранилища(СтруктураОбмена.Картинки);
		ДвоичныеДанныеФайла.Записать(ПутьКДопФайлу);
		КопироватьФайл(ПутьКДопФайлу, АдресКаталога + "Additional files" + ".zip");
		СтруктураФайловЭД.Вставить("ДополнительныйФайл", "Additional files" + ".zip");
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ПутьКДопФайлу);
	КонецЕсли;
	
	// Формируем meta.xml.
	ОбменСКонтрагентамиВнутренний.СформироватьТранспортнуюИнформацию(СтруктураОбмена.СтруктураЭД,
		СтруктураФайловЭД, АдресКаталога, Ошибки, Неопределено);
	
	// Формируем card.xml.
	ОбменСКонтрагентамиВнутренний.СформироватьКарточку(СтруктураОбмена.СтруктураЭД, АдресКаталога, Ошибки);
	
	Если Не ЗначениеЗаполнено(Ошибки) Тогда
		
		Контейнер = Новый ЗаписьZipФайла();
		ИмяФайлаАрхива = ОбменСКонтрагентамиСлужебный.ТекущееИмяВременногоФайла("zip");

		Контейнер.Открыть(ИмяФайлаАрхива);
		
		ОбъектыДобавляемыеВАрхив = АдресКаталога + "*";
		Контейнер.Добавить(ОбъектыДобавляемыеВАрхив, РежимСохраненияПутейZIP.СохранятьОтносительныеПути,
		РежимОбработкиПодкаталоговZIP.ОбрабатыватьРекурсивно);
		
		Попытка
			Контейнер.Записать();
			ДвоичныеДанныеПакета = Новый ДвоичныеДанные(ИмяФайлаАрхива);
		Исключение
			ТекстСообщения = КраткоеПредставлениеОшибки(ИнформацияОбОшибке());
			ЭлектронноеВзаимодействиеСлужебныйВызовСервера.ОбработатьОшибку(
				НСтр("ru = 'Формирование пакета ЭД - однократная сделка'"), ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()),
				ТекстСообщения);
		КонецПопытки;
		ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(ИмяФайлаАрхива);
		
		// Подготовка двоичных данных представления для 1С:Бизнес-сеть
		Если СтруктураОбмена.Свойство("ДвоичныеДанныеПредставления") Тогда
			ИмяФайлаПДФ = СформироватьФайлПредставления(СтруктураОбмена, ТипФайлаТабличногоДокумента.PDF, Истина);
			Если ЗначениеЗаполнено(ИмяФайлаПДФ) Тогда
				КопироватьФайл(ИмяФайлаПДФ, АдресКаталога + НаименованиеФайла + ".pdf");
				СтруктураОбмена.ДвоичныеДанныеПредставления = Новый ДвоичныеДанные(ИмяФайлаПДФ);
			КонецЕсли; 
		КонецЕсли;
	
	Иначе
		ШаблонСообщения = НСтр("ru = 'При формировании %1 возникли следующие ошибки:
		|%2'");
		ТекстОшибки = ЭлектронноеВзаимодействиеСлужебный.СоединитьОшибки(Ошибки);
		ТекстСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонСообщения, СтруктураОбмена.ВидЭД,
			ТекстОшибки);
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
	ЭлектронноеВзаимодействиеСлужебный.УдалитьВременныеФайлы(АдресКаталога);
	Возврат ДвоичныеДанныеПакета;
	
КонецФункции

//ОКЕЙ Назаренко Д.В. (СофтЛаб) Начало 2021-01-12 #3997
Функция ПроверитьДокументыПередСогласованием(Список) Экспорт
	
	Отказ = Ложь;
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ЭлектронныйДокументВходящий.Ссылка КАК Ссылка,
	               |	ЭлектронныйДокументВходящий.Номер КАК Номер,
	               |	ЭлектронныйДокументВходящий.Дата КАК Дата,
	               |	ЭлектронныйДокументВходящий.ок_ЦФО КАК ок_ЦФО,
	               |	ЭлектронныйДокументВходящий.ок_ФункциональныйДиректор КАК ок_ФункциональныйДиректор
	               |ИЗ
	               |	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
	               |ГДЕ
	               |	ЭлектронныйДокументВходящий.Ссылка В(&Список)
	               |	И ЭлектронныйДокументВходящий.ок_ТребуетсяСогласованиеФД
	               |	И (ЭлектронныйДокументВходящий.ок_ЦФО = ЗНАЧЕНИЕ(Справочник.Подразделения.ПустаяСсылка)
	               |			ИЛИ ЭлектронныйДокументВходящий.ок_ФункциональныйДиректор = ЗНАЧЕНИЕ(Справочник.бит_БК_Инициаторы.ПустаяСсылка))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ЭлектронныйДокументВходящий.Ссылка КАК Ссылка,
	               |	ЭлектронныйДокументВходящий.Номер КАК Номер,
	               |	ЭлектронныйДокументВходящий.Дата КАК Дата,
	               |	ЭлектронныйДокументВходящийок_Инициаторы.Инициатор КАК Инициатор,
	               |	ЭлектронныйДокументВходящийок_Инициаторы.Инициатор.Пользователь КАК ИнициаторПользователь,
	               |	ЭлектронныйДокументВходящийок_Инициаторы.Инициатор.Email КАК ИнициаторEmail
	               |ИЗ
	               |	Документ.ЭлектронныйДокументВходящий КАК ЭлектронныйДокументВходящий
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Документ.ЭлектронныйДокументВходящий.ок_Инициаторы КАК ЭлектронныйДокументВходящийок_Инициаторы
	               |		ПО ЭлектронныйДокументВходящийок_Инициаторы.Ссылка = ЭлектронныйДокументВходящий.Ссылка
	               |ГДЕ
	               |	ЭлектронныйДокументВходящий.Ссылка В(&Список)
	               |ИТОГИ ПО
	               |	Ссылка";
	 
	Запрос.УстановитьПараметр("Список", Список);
	 
	ПакетЗапросов = Запрос.ВыполнитьПакет();
	 
	Выборка = ПакетЗапросов[0].Выбрать();
	Пока Выборка.Следующий() Цикл				
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Маршрут не может быть запущен по документу № " + Выборка.Номер + " от " + Выборка.Дата + ", т.к. не заполнено поле " + ?(ЗначениеЗаполнено(Выборка.ок_ЦФО),"Функциональный директор","ЦФО") +" для согласования ФД.", Выборка.Ссылка,,,Отказ); 
	КонецЦикла;
	
	ВыборкаДокументов = ПакетЗапросов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаДокументов.Следующий() Цикл
		ДетальныеЗаписи = ВыборкаДокументов.Выбрать();
		Пока ДетальныеЗаписи.Следующий() Цикл
			
			Если Не ЗначениеЗаполнено(ДетальныеЗаписи.Инициатор) Тогда	
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("Не удалось отправить на согласование №" + ДетальныеЗаписи.Номер + " от " + ДетальныеЗаписи.Дата + ". Не заполнен инициатор.", ДетальныеЗаписи.Ссылка,,,Отказ); 				
				Прервать;
			КонецЕсли;	
			
			Если Не ЗначениеЗаполнено(ДетальныеЗаписи.ИнициаторEmail) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("У инициатора " + ДетальныеЗаписи.Инициатор + " не заполнен адрес электронной почты.", ДетальныеЗаписи.Инициатор,,,Отказ); 
			КонецЕсли;
						
			Если Не ЗначениеЗаполнено(ДетальныеЗаписи.ИнициаторПользователь) Тогда //при загрузке проверяется только по справочнику пользователей, поэтому если не проверить, то будет ошибка
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю("У инициатора " + ДетальныеЗаписи.Инициатор + " не заполнен пользователь.", ДетальныеЗаписи.Инициатор,,,Отказ); 
			КонецЕсли;
						
		КонецЦикла; 
		
	КонецЦикла;
			 
	Возврат Отказ;
	
КонецФункции
//ОКЕЙ Назаренко Д.В. (СофтЛаб) Конец  2021-01-12 #3997

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция БыстрыйОбменИмяСохраняемогоФайла(Основание)
	
	Если ТипЗнч(Основание) = Тип("Массив") Тогда
		Ссылка = Основание[0];
	Иначе
		Ссылка = Основание;
	КонецЕсли;
	
	НаименованиеФайла = "";
	ОбменСКонтрагентамиПереопределяемый.ЗадатьИмяСохраняемогоФайлаПриБыстромОбмене(Ссылка, НаименованиеФайла);
	Если ЗначениеЗаполнено(Ссылка) И НЕ ЗначениеЗаполнено(НаименованиеФайла) Тогда
		
		СправочникОрганизации = ЭлектронноеВзаимодействиеСлужебныйПовтИсп.ИмяПрикладногоСправочника("Организации");
		
		Если ТипЗнч(Ссылка) = Тип("СправочникСсылка." + СправочникОрганизации) Тогда
			СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Наименование");
			ШаблонФайла = НСтр("ru = '%1'");
			НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, СтруктураРеквизитов.Наименование);
		ИначеЕсли ТипЗнч(Основание) = Тип("Структура") Тогда
			// Бизнес-сеть.
			ШаблонФайла = НСтр("ru = '%1 %2 от %3'");
			НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, Основание.ВидЭД,
				Основание.Номер, Формат(Основание.Дата, "ДЛФ=Д"));
		Иначе
			
			МетаданныеОбъекта = Ссылка.Метаданные();
			
			Если ОбщегоНазначения.ЕстьРеквизитОбъекта("Номер", МетаданныеОбъекта)
				И ОбщегоНазначения.ЕстьРеквизитОбъекта("Дата", МетаданныеОбъекта) Тогда
				
				СтруктураРеквизитов = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Ссылка, "Номер, Дата");
				ШаблонФайла = НСтр("ru = '%1 %2 от %3'");
				НаименованиеФайла = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(ШаблонФайла, Строка(ТипЗнч(Ссылка)),
					СтруктураРеквизитов.Номер, Формат(СтруктураРеквизитов.Дата, "ДЛФ=Д"));
				
			Иначе
				НаименованиеФайла = Строка(Новый УникальныйИдентификатор);
			КонецЕсли;
			
		КонецЕсли;
		
		НаименованиеФайла = ОбщегоНазначенияКлиентСервер.ЗаменитьНедопустимыеСимволыВИмениФайла(НаименованиеФайла);
		
	КонецЕсли;
	
	Возврат НаименованиеФайла;
	
КонецФункции

Функция СформироватьФайлПредставления(СтруктураОбмена, ТипФайла = Неопределено, СкрыватьСлужебныеОбласти = Ложь)
	
	Если ТипФайла = Неопределено Тогда
		ТипФайла = ТипФайлаТабличногоДокумента.PDF;
	КонецЕсли;
	
	ФайлИсходногоДокумента = Новый Файл(СтруктураОбмена.ПолноеИмяФайла);
	ИмяИсходногоДокумента  = ФайлИсходногоДокумента.ИмяБезРасширения;
	
	ПолноеИмяДопФайла = Неопределено;
	СтруктураОбмена.Свойство("ПолноеИмяДопФайла", ПолноеИмяДопФайла);
	
	ПараметрыПечати = Новый Структура("ПолноеИмяДопФайла",     ПолноеИмяДопФайла);
	ПараметрыПечати.Вставить("СкрыватьИдентификаторДокумента", СкрыватьСлужебныеОбласти);
	ПараметрыПечати.Вставить("СкрыватьКопияВерна",             СкрыватьСлужебныеОбласти);
	
	УстановитьПривилегированныйРежим(Истина); // на случай отсутствия у пользователя права на вывод
	
	ТабличныйДокумент = ОбменСКонтрагентамиВнутренний.СформироватьПечатнуюФормуЭД(СтруктураОбмена.ПолноеИмяФайла,
		СтруктураОбмена.СтруктураЭД.НаправлениеЭД, ПараметрыПечати);
	
	Если ТабличныйДокумент <> Неопределено Тогда
		ФайлСохранения = ФайлИсходногоДокумента.Путь + ИмяИсходногоДокумента +"." + НРег(ТипФайла);
		ТабличныйДокумент.Записать(ФайлСохранения, ТипФайла);
	Иначе
		ТекстСообщения = НСтр("ru = 'Не удалось сформировать табличный документ.
			|Подробности см. в журнале регистрации.'");
		ОбщегоНазначения.СообщитьПользователю(ТекстСообщения);
		ФайлСохранения = Неопределено;
	КонецЕсли;
	
	Возврат ФайлСохранения;
	
	УстановитьПривилегированныйРежим(Ложь);
	
КонецФункции

#КонецОбласти



#КонецЕсли