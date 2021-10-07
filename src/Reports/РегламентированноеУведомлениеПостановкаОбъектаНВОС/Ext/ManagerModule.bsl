﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#КонецОбласти

#Область СлужебныеПроцедурыИФункции
Функция ДанноеУведомлениеДоступноДляОрганизации() Экспорт 
	Возврат Истина;
КонецФункции

Функция ДанноеУведомлениеДоступноДляИП() Экспорт 
	Возврат Истина;
КонецФункции

Функция ПолучитьОсновнуюФорму() Экспорт 
	Возврат "";
КонецФункции

Функция ПолучитьФормуПоУмолчанию() Экспорт 
	//Возврат "Отчет.РегламентированноеУведомлениеПостановкаОбъектаНВОС.Форма.Форма2016_1";
	Возврат "";
КонецФункции

Функция ПолучитьТаблицуФорм() Экспорт 
	Результат = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПустуюТаблицуФормУведомления();
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2015_1";
	Стр.ОписаниеФормы = "Форма заявления для печати по приказу Минприроды России от 23.12.2015 № 554";
	
	Стр = Результат.Добавить();
	Стр.ИмяФормы = "Форма2016_1";
	Стр.ОписаниеФормы = "Элекронное представление заявления в формате Росприроднадзора";
	
	Возврат Результат;
КонецФункции

Функция ПечатьСразу(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат ПечатьСразу_Форма2015_1(Объект);
	ИначеЕсли ИмяФормы = "Форма2016_1" Тогда
		ВызватьИсключение "Печать электронного представления заявления не предусмотрена";
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция СформироватьМакет(Объект, ИмяФормы) Экспорт
	Если ИмяФормы = "Форма2015_1" Тогда
		Возврат СформироватьМакет_Форма2015_1(Объект);
	ИначеЕсли ИмяФормы = "Форма2016_1" Тогда
		ВызватьИсключение "Печать электронного представления заявления не предусмотрена";
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ЭлектронноеПредставление(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2016_1" Тогда
		Возврат ЭлектронноеПредставление_Форма2016_1(Объект, УникальныйИдентификатор);
	КонецЕсли;
	Возврат Неопределено;
КонецФункции

Функция ПроверитьДокумент(Объект, ИмяФормы, УникальныйИдентификатор) Экспорт
	Если ИмяФормы = "Форма2016_1" Тогда
		Попытка
			Данные = Объект.ДанныеУведомления.Получить();
			Проверить_Форма2016_1(Данные, УникальныйИдентификатор);
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("Проверка уведомления прошла успешно.", УникальныйИдентификатор);
		Исключение
			РегламентированнаяОтчетность.СообщитьПользователюОбОшибкеВУведомлении("При проверке уведомления обнаружены ошибки.", УникальныйИдентификатор);
		КонецПопытки;
	КонецЕсли;
КонецФункции

Функция СформироватьМакет_Форма2015_1(Объект)
	ПечатнаяФорма = Новый ТабличныйДокумент;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_УведомлениеОСпецрежимах_"+Объект.ВидУведомления.Метаданные().Имя;
	
	МакетУведомления = Отчеты[Объект.ИмяОтчета].ПолучитьМакет("Печать_MXL_Форма2015_1");
	ПечатнаяФорма.Вывести(МакетУведомления);
	СтруктураПараметров = Объект.ДанныеУведомления.Получить().ДанныеУведомления;
	Для Каждого КЗ Из СтруктураПараметров Цикл 
		Обл = ПечатнаяФорма.Области.Найти(КЗ.Ключ);
		Если Обл <> Неопределено Тогда 
			Обл.Значение = КЗ.Значение;
		КонецЕсли
	КонецЦикла;
	
	Возврат ПечатнаяФорма;
КонецФункции

Функция ПечатьСразу_Форма2015_1(Объект)
	
	ПечатнаяФорма = СформироватьМакет_Форма2015_1(Объект);
	
	ПечатнаяФорма.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
	ПечатнаяФорма.АвтоМасштаб = Истина;
	ПечатнаяФорма.ПолеСверху = 0;
	ПечатнаяФорма.ПолеСнизу = 0;
	ПечатнаяФорма.ПолеСлева = 0;
	ПечатнаяФорма.ПолеСправа = 0;
	ПечатнаяФорма.ОбластьПечати = ПечатнаяФорма.Область();
	
	Возврат ПечатнаяФорма;
	
КонецФункции

Процедура ЗаполнитьУзел(Узел, Стр, ИмяИД, МодульРаботаСФайлами)
	Узел_Тек = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Узел);
	
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, ИмяИД, СтрЗаменить(Строка(Стр.УИД), "-", ""));
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "DATE_DOC", Формат(Стр.ДатаВыдачи, "ДФ=yyyy-MM-dd"));
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "DATE_BEGIN", Формат(Стр.ДатаНачалаДействия, "ДФ=yyyy-MM-dd"));
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "DATE_END", Формат(Стр.ДатаОкончанияДействия, "ДФ=yyyy-MM-dd"));
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "NUM_DOC", Стр.НомерДокумента);
	Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "ISSUED_NAME", Стр.Орган);
	
	Если ЗначениеЗаполнено(Стр.ПрисоединенныйФайл) Тогда
		
		КаталогВремФайлов = "";
		ИмяФайла = Стр.ИмяФайла;
		ИмяПрисоединенногоФайла = РегламентированнаяОтчетностьКлиентСервер.ПолучитьПолноеИмяВременногоФайла(
																		КаталогВремФайлов, ИмяФайла, Истина);
		
		МодульРаботаСФайлами.ДвоичныеДанныеФайла(Стр.ПрисоединенныйФайл).Записать(ИмяПрисоединенногоФайла);
		
		НовыйАрхивИмя = ПолучитьИмяВременногоФайла();
		НовыйАрхив = Новый ЗаписьZIPФайла(НовыйАрхивИмя,,,МетодСжатияZIP.Копирование);
		НовыйАрхив.Добавить(ИмяПрисоединенногоФайла, РежимСохраненияПутейZIP.НеСохранятьПути);
		НовыйАрхив.Записать();
		
		МассивДляУдаления = Новый Массив;
		МассивДляУдаления.Добавить(ИмяПрисоединенногоФайла);
			
		ДанныеАрхива = Новый ДвоичныеДанные(НовыйАрхивИмя);
		Base64СтрокаДанныеАрхива = СтрЗаменить(Base64Строка(ДанныеАрхива), Символы.ПС, "");
		Base64СтрокаДанныеАрхива = СтрЗаменить(Base64СтрокаДанныеАрхива, Символы.ВК, "");
		
		МассивДляУдаления.Добавить(НовыйАрхивИмя);
		Для Каждого ФайлДляУдаления Из МассивДляУдаления Цикл 
			УдалитьФайлы(ФайлДляУдаления);
		КонецЦикла;
		УдалитьФайлы(КаталогВремФайлов);
		
		Документы.УведомлениеОСпецрежимахНалогообложения.УстановитьЗначениеЭлемента(Узел_Тек, "ATTACH", Base64СтрокаДанныеАрхива);
		
	КонецЕсли;
КонецПроцедуры

Функция ПолучитьСписокТиповСопровождающихДокументов() Экспорт 
	Рез = Новый Массив;
	Рез.Добавить("Разрешение на выброс ЗВ в атмосферу стационарными источниками");
	Рез.Добавить("Разрешение на сброс ЗВ в окружающую среду (водные объекты)");
	Рез.Добавить("Документ об утверждении нормативов образования отходов и лимитов на их размещение");
	
	Возврат Рез;
КонецФункции

Функция ИдентификаторФайлаЭлектронногоПредставления_Форма2016_1(СведенияОтправки)
	Префикс = "онв_" + СтрЗаменить(СведенияОтправки.SNAME, """", "") + "_" + Формат(СведенияОтправки.ТекущаяДатаСеанса, "ДФ=yyyy-MM-dd_HH-mm-ss");
	Возврат Префикс;
КонецФункции

Процедура Проверить_Форма2016_1(Данные, УникальныйИдентификатор)
КонецПроцедуры

Функция ОсновныеСведенияЭлектронногоПредставления_Форма2016_1(Объект, УникальныйИдентификатор)
	ОсновныеСведения = Новый Структура;
	ОсновныеСведения.Вставить("ВерсПрог", РегламентированнаяОтчетностьПереопределяемый.КраткоеНазваниеПрограммы());
	ОсновныеСведения.Вставить("ДатаДок", Формат(Объект.ДатаПодписи, "ДФ=dd.MM.yyyy"));
	
	Данные = Объект.ДанныеУведомления.Получить();
	ОсновныеСведения.Вставить("ДатаСозд", Объект.Дата);
	ОсновныеСведения.Вставить("SNAME", Данные.ДанныеУведомления.ORG_INFO.SNAME);
	ОсновныеСведения.Вставить("ТекущаяДатаСеанса", ТекущаяДатаСеанса());
	ИдентификаторФайла = ИдентификаторФайлаЭлектронногоПредставления_Форма2016_1(ОсновныеСведения);
	ОсновныеСведения.Вставить("ИдФайл", ИдентификаторФайла);
	ОсновныеСведения.Вставить("КодПредставляетсяВ", Данные.ДанныеУведомления.ORG_INFO.RPN_CODE);
	ОсновныеСведения.Вставить("ОтчетныйГод", Формат(Год(ТекущаяДатаСеанса()), "ЧГ=0"));
	
	Если Данные.ДанныеУведомления.ORG_INFO.Свойство("CALC_TYPE") Тогда 
		ОсновныеСведения.Вставить("ВидРасчета", Данные.ДанныеУведомления.ORG_INFO.CALC_TYPE);
	Иначе 
		ОсновныеСведения.Вставить("ВидРасчета", "1");
	КонецЕсли;
	ОсновныеСведения.Вставить("ИННЮЛ", Данные.ДанныеУведомления.ORG_INFO.INN);
	ОсновныеСведения.Вставить("КППЮЛ", Данные.ДанныеУведомления.ORG_INFO.KPP);
	ОсновныеСведения.Вставить("ОГРН", Данные.ДанныеУведомления.ORG_INFO.OGRN);
	ОсновныеСведения.Вставить("ДатаФормирования", Формат(ОсновныеСведения.ТекущаяДатаСеанса, "ДФ=yyyy-MM-ddTHH:mm:ssZ"));
	
	Возврат ОсновныеСведения;
КонецФункции

Функция ВыгрузитьДеревоВXML(ДеревоВыгрузки, Параметры) Экспорт 
	
	ПотокXML = РегламентированнаяОтчетность.СоздатьНовыйПотокXML(); // создаем новый поток для записи
	ЗаписатьУзелДереваВXML(ДеревоВыгрузки, ПотокXML, Параметры); // пишем дерево в поток
	ТекстДляЗаписи = ПотокXML.Закрыть(); // получаем текст XML
	ТекстДляЗаписи = "<?xml version=""1.0"" encoding=""utf-8""?>" + Сред(ТекстДляЗаписи, СтрНайти(ТекстДляЗаписи, Символы.ПС));
	Возврат ТекстДляЗаписи;
	
КонецФункции

Функция ЗаписатьУзелДереваВXML(СтрокаДерева, ПотокXML, Параметры)
	
	Если ТипЗнч(СтрокаДерева) = Тип("ДеревоЗначений") Тогда
		Для Каждого Стр Из СтрокаДерева.Строки Цикл
			ЗаписатьУзелДереваВXML(Стр, ПотокXML, Параметры);
		КонецЦикла;
	Иначе
		Если СтрокаДерева.Тип = "А" ИЛИ СтрокаДерева.Тип = "A" Тогда 
			ПотокXML.ЗаписатьАтрибут(СтрокаДерева.Код, Строка(СтрокаДерева.Значение));
		ИначеЕсли СтрокаДерева.Тип = "C" ИЛИ СтрокаДерева.Тип = "С" Тогда 
			ПотокXML.ЗаписатьНачалоЭлемента(СтрокаДерева.Код);
			Для Каждого Лист из СтрокаДерева.Строки Цикл
				ЗаписатьУзелДереваВXML(Лист, ПотокXML, Параметры);
			КонецЦикла;
			ПотокXML.ЗаписатьТекст(Строка(СтрокаДерева.Значение));
			ПотокXML.ЗаписатьКонецЭлемента();
		ИначеЕсли СтрокаДерева.Тип = "П" Тогда
			ПотокXML.ЗаписатьНачалоЭлемента(СтрокаДерева.Код);
			ПотокXML.ЗаписатьТекст(Строка(СтрокаДерева.Значение));
			ПотокXML.ЗаписатьКонецЭлемента();
		КонецЕсли;
	КонецЕсли;

КонецФункции

Функция ЭлектронноеПредставление_Форма2016_1(Объект, УникальныйИдентификатор)
	ПроизвольнаяСтрока = Новый ОписаниеТипов("Строка");
	
	СведенияЭлектронногоПредставления = Новый ТаблицаЗначений;
	СведенияЭлектронногоПредставления.Колонки.Добавить("ИмяФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("ТекстФайла", ПроизвольнаяСтрока);
	СведенияЭлектронногоПредставления.Колонки.Добавить("КодировкаТекста", ПроизвольнаяСтрока);
	
	ОсновныеСведения = ОсновныеСведенияЭлектронногоПредставления_Форма2016_1(Объект, УникальныйИдентификатор);
	СтруктураВыгрузки = Документы.УведомлениеОСпецрежимахНалогообложения.ИзвлечьСтруктуруXMLУведомления(Объект.ИмяОтчета, "СхемаВыгрузкиФорма2016_1");
	ЗаполнитьДанными_Форма2016_1(Объект, ОсновныеСведения, СтруктураВыгрузки);
	ЗаполнитьДаннымиПриложенныхДокументов(Объект, ОсновныеСведения, СтруктураВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ОтсечьНезаполненныеНеобязательныеУзлы(СтруктураВыгрузки);
	
	Текст = ВыгрузитьДеревоВXML(СтруктураВыгрузки, ОсновныеСведения);
	
	СтрокаСведенийЭлектронногоПредставления = СведенияЭлектронногоПредставления.Добавить();
	СтрокаСведенийЭлектронногоПредставления.ИмяФайла = ОсновныеСведения.ИдФайл + ".xml";
	СтрокаСведенийЭлектронногоПредставления.ТекстФайла = Текст;
	СтрокаСведенийЭлектронногоПредставления.КодировкаТекста = "utf-8";
	
	Если СведенияЭлектронногоПредставления.Количество() = 0 Тогда
		СведенияЭлектронногоПредставления = Неопределено;
	КонецЕсли;
	Возврат СведенияЭлектронногоПредставления;
КонецФункции

Процедура ЗаполнитьДанными_Форма2016_1(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	ДанныеУведомления = Объект.ДанныеУведомления.Получить();
	ДополнитьПараметры(ДанныеУведомления);
	ЗаполнитьДаннымиУзел(ДанныеУведомления, ДеревоВыгрузки);
КонецПроцедуры

Функция СтраницаЗаполнена(Данные)
	Если ТипЗнч(Данные) = Тип("Структура") Тогда 
		Для Каждого КЗ Из Данные Цикл 
			Если ТипЗнч(КЗ.Значение) = Тип("УникальныйИдентификатор") Тогда 
				Продолжить;
			КонецЕсли;
			Если ЗначениеЗаполнено(КЗ.Значение) Тогда 
				Возврат Истина
			КонецЕсли;
		КонецЦикла;
		Возврат Ложь;
	КонецЕсли;
	
	Возврат Истина;
КонецФункции

Процедура ДополнитьПараметры(Параметры)
	ID_ORG = СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
	ID_EO = СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", "");
	
	Параметры.ДанныеУведомления.ORG_INFO.Вставить("ID_ORG", ID_ORG);
	Если Параметры.ДанныеУведомления.ORG_INFO.FINDIVID_BOOL = Неопределено Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("FINDIVID", "false");
	Иначе
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("FINDIVID", ?(Параметры.ДанныеУведомления.ORG_INFO.FINDIVID_BOOL, "true", "false"));
	КонецЕсли;
	
	Параметры.ДанныеДопСтрокБД.OKVED.Колонки.Добавить("IS_MAIN");
	Для Каждого Стр Из Параметры.ДанныеДопСтрокБД.OKVED Цикл 
		Если ЗначениеЗаполнено(Стр.OKVED_CODE) Тогда 
			Стр.IS_MAIN = "true";
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Если Параметры.ДанныеУведомления.ORG_INFO.Свойство("SEP_DIV_BOOL") Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("SEP_DIV", ?(Параметры.ДанныеУведомления.ORG_INFO.SEP_DIV_BOOL = Истина, "true", "false"));
	Иначе
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("SEP_DIV", "false");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.ORG_INFO.REG_DATE_DATE) Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("REG_DATE", Формат(Параметры.ДанныеУведомления.ORG_INFO.REG_DATE_DATE, "ДФ=yyyy-MM-dd"));
	КонецЕсли;
	Если Параметры.ДанныеУведомления.ORG_INFO.Свойство("EGRULIP_DATE_DATE")
		И ЗначениеЗаполнено(Параметры.ДанныеУведомления.ORG_INFO.EGRULIP_DATE_DATE) Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("EGRULIP_DATE", Формат(Параметры.ДанныеУведомления.ORG_INFO.EGRULIP_DATE_DATE, "ДФ=yyyy-MM-dd"));
	КонецЕсли;
	Если Параметры.ДанныеУведомления.ORG_INFO.Свойство("ENTRY_DATE_DATE")
		И ЗначениеЗаполнено(Параметры.ДанныеУведомления.ORG_INFO.ENTRY_DATE_DATE) Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("ENTRY_DATE", Формат(Параметры.ДанныеУведомления.ORG_INFO.ENTRY_DATE_DATE, "ДФ=yyyy-MM-dd"));
	КонецЕсли;
	Если Не Параметры.ДанныеУведомления.ORG_INFO.Свойство("MANUFACTURER_BOOL")
		Или Параметры.ДанныеУведомления.ORG_INFO.MANUFACTURER_BOOL = Неопределено Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("MANUFACTURER", "");
	Иначе
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("MANUFACTURER", ?(Параметры.ДанныеУведомления.ORG_INFO.MANUFACTURER_BOOL, "true", "false"));
	КонецЕсли;
	Если Не Параметры.ДанныеУведомления.ORG_INFO.Свойство("IMPORTER_BOOL")
		Или Параметры.ДанныеУведомления.ORG_INFO.IMPORTER_BOOL = Неопределено Тогда 
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("IMPORTER", "");
	Иначе
		Параметры.ДанныеУведомления.ORG_INFO.Вставить("IMPORTER", ?(Параметры.ДанныеУведомления.ORG_INFO.IMPORTER_BOOL, "true", "false"));
	КонецЕсли;
	
	Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("ID_EO", ID_EO);
	Если Параметры.ДанныеУведомления.EMISS_OBJECT.IS_BOAT_BOOL = Неопределено Тогда 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("IS_BOAT", "");
	Иначе
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("IS_BOAT", ?(Параметры.ДанныеУведомления.EMISS_OBJECT.IS_BOAT_BOOL, "true", "false"));
	КонецЕсли;
	Если Параметры.ДанныеУведомления.EMISS_OBJECT.Свойство("POPUL_LOC_BOOL") Тогда 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("POPUL_LOC", ?(Параметры.ДанныеУведомления.EMISS_OBJECT.POPUL_LOC_BOOL = Истина, "true", "false"));
	Иначе
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("POPUL_LOC", "false");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.EMISS_OBJECT.EXPL_DATE_DATE) Тогда 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("EXPL_DATE", Формат(Параметры.ДанныеУведомления.EMISS_OBJECT.EXPL_DATE_DATE, "ДФ=yyyy-MM-dd"));
	Иначе 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("EXPL_DATE", "");
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ДанныеУведомления.EMISS_OBJECT.GEE_DATE_DATE) Тогда 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("GEE_DATE", Формат(Параметры.ДанныеУведомления.EMISS_OBJECT.GEE_DATE_DATE, "ДФ=yyyy-MM-dd"));
	Иначе 
		Параметры.ДанныеУведомления.EMISS_OBJECT.Вставить("GEE_DATE", "");
	КонецЕсли;
	
	Параметры.ДанныеДопСтрокБД.OBJ_REDUCE_ACTION.Колонки.Добавить("ORA_PLAN_DATE_BEGIN");
	Параметры.ДанныеДопСтрокБД.OBJ_REDUCE_ACTION.Колонки.Добавить("ORA_PLAN_DATE_END");
	Для Каждого Стр Из Параметры.ДанныеДопСтрокБД.OBJ_REDUCE_ACTION Цикл
		Стр.ORA_PLAN_DATE_BEGIN = ?(ЗначениеЗаполнено(Стр.ORA_PLAN_DATE_BEGIN_DATE), Формат(Стр.ORA_PLAN_DATE_BEGIN_DATE, "ДФ=yyyy-MM-dd"), "");
		Стр.ORA_PLAN_DATE_END = ?(ЗначениеЗаполнено(Стр.ORA_PLAN_DATE_END_DATE), Формат(Стр.ORA_PLAN_DATE_END_DATE, "ДФ=yyyy-MM-dd"), "");
	КонецЦикла;
	
	Параметры.ДанныеДопСтрокБД.OBJ_MEASURING.Колонки.Добавить("POL_KIND");
	Для Каждого Стр Из Параметры.ДанныеДопСтрокБД.OBJ_MEASURING Цикл
		Стр.POL_KIND = Стр.POL_KIND1;
	КонецЦикла;
	
	Параметры.ДанныеДопСтрокБД.OBJ_DISP_MEANS.Колонки.Добавить("UM_CODE");
	Параметры.ДанныеДопСтрокБД.OBJ_DISP_MEANS.Колонки.Добавить("UM_NAME");
	Для Каждого Стр Из Параметры.ДанныеДопСтрокБД.OBJ_DISP_MEANS Цикл
		Стр.UM_CODE = Стр.UM_CODE1;
		Стр.UM_NAME = Стр.UM_NAME1;
	КонецЦикла;
	
	Для Каждого Стр Из Параметры.ДанныеМногостраничныхРазделов.WASTE_OBJECT Цикл
		ПарамСтр = Стр.Значение;
		Если СтраницаЗаполнена(ПарамСтр) Тогда 
			ПарамСтр.Вставить("ID_WSO", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
			ПарамСтр.Вставить("ID_EO", ID_EO);
		КонецЕсли;
	КонецЦикла;
	
	Инд = 0;
	Для Каждого Стр Из Параметры.ДанныеМногостраничныхРазделов.WATER_OBJECT Цикл
		ПарамСтр = Стр.Значение;
		Если СтраницаЗаполнена(ПарамСтр) Тогда
			Инд = Инд + 1;
			ПарамСтр.Вставить("ID_WO", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
			Если ПарамСтр.POPUL_LOC_BOOL <> Неопределено Тогда
				ПарамСтр.Вставить("POPUL_LOC", ?(ПарамСтр.POPUL_LOC_BOOL, "true", "false"));
			КонецЕсли;
			Если ПарамСтр.DRINK_WTS_BOOL <> Неопределено Тогда
				ПарамСтр.Вставить("DRINK_WTS", ?(ПарамСтр.DRINK_WTS_BOOL, "true", "false"));
			КонецЕсли;
			ПарамСтр.Вставить("DOC_DATE", ?(ЗначениеЗаполнено(ПарамСтр.DOC_DATE_DATE), Формат(ПарамСтр.DOC_DATE_DATE, "ДФ=yyyy-MM-dd"), ""));
			ПарамСтр.Вставить("OBJ_ORD_NUMB", Инд);
			ПарамСтр.Вставить("ID_EO", ID_EO);
		КонецЕсли;
	КонецЦикла;
	
	Для Каждого Стр Из Параметры.ДанныеМногостраничныхРазделов.EMISS_DEP_OBJECT Цикл
		ПарамСтр = Стр.Значение;
		Если СтраницаЗаполнена(ПарамСтр) Тогда
			ПарамСтр.Вставить("ID_EDO", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
			ПарамСтр.Вставить("ID_EO", ID_EO);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДаннымиУзел(ПараметрыВыгрузки, Узел, НомерСтроки = Неопределено) Экспорт 
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если ПустаяСтрока(Стр.ЗначениеПоУмолчанию) Тогда
			Если Стр.Многостраничность = Истина Тогда
				Многостраничность = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Код, Многостраничность)
					И ТипЗнч(Многостраничность) = Тип("СписокЗначений") Тогда 
					
					Для Каждого СтрМнгч Из Многостраничность Цикл 
						НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
						
						ЗначениеПоказателя = Неопределено;
						Если ЗначениеЗаполнено(НовУзел.Ключ) И СтрМнгч.Значение.Свойство(НовУзел.Ключ, ЗначениеПоказателя) Тогда 
							РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(НовУзел, ЗначениеПоказателя);
						ИначеЕсли СтрМнгч.Значение.Свойство(НовУзел.Код, ЗначениеПоказателя) Тогда
							РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(НовУзел, ЗначениеПоказателя);
						КонецЕсли;
						ЗаполнитьДаннымиСтраницу(ПараметрыВыгрузки, СтрМнгч.Значение, НовУзел);
					КонецЦикла;
				КонецЕсли;
			Иначе
				ДанныеСтраницы = Неопределено;
				Если ПараметрыВыгрузки.ДанныеУведомления.Свойство(Стр.Код, ДанныеСтраницы)
					И ТипЗнч(ДанныеСтраницы) = Тип("Структура") Тогда 
					
					Если СтраницаЗаполнена(ДанныеСтраницы) Тогда 
						ЗаполнитьДаннымиОбычнуюСтраницу(ПараметрыВыгрузки, ДанныеСтраницы, Стр);
					КонецЕсли;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		Если Стр.Тип = "С" ИЛИ Стр.Тип = "C" Тогда // учтем оба варианта: кириллицу и латиницу
			ЗаполнитьДаннымиУзел(ПараметрыВыгрузки, Стр, НомерСтроки);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДаннымиОбычнуюСтраницу(ПараметрыВыгрузки, ПараметрыСтраницы, Узел)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		Если ПустаяСтрока(Стр.ЗначениеПоУмолчанию) Тогда
			ЗначениеПоказателя = Неопределено;
			Если ПараметрыСтраницы.Свойство(Стр.Код, ЗначениеПоказателя) Тогда 
				РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
			КонецЕсли;
		КонецЕсли;
		
		Если (Стр.Тип = "С" ИЛИ Стр.Тип = "C") Тогда
			Если Стр.Многострочность = Истина Тогда 
				МногострочнаяЧасть = Неопределено;
				Если ПараметрыВыгрузки.ДанныеДопСтрокБД.Свойство(Стр.Код, МногострочнаяЧасть) Тогда
					МногострочнаяЧастьСтроки = МногострочнаяЧасть.НайтиСтроки(Новый Структура("УИД", ПараметрыВыгрузки.ИдентификаторыОбычныхСтраниц[Узел.Код]));
					Для Каждого Строка Из МногострочнаяЧастьСтроки Цикл 
						НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
						ЗаполнитьСтроки(ПараметрыВыгрузки, ПараметрыСтраницы, НовУзел, Строка);
					КонецЦикла;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДаннымиСтраницу(ПараметрыВыгрузки, ПараметрыСтраницы, Узел, УИДРодителя = Неопределено)
	СтрокиУзла = Новый Массив;
	Для Каждого Стр Из Узел.Строки Цикл
		СтрокиУзла.Добавить(Стр);
	КонецЦикла;
	
	Для Каждого Стр из СтрокиУзла Цикл
		
		Если ПустаяСтрока(Стр.ЗначениеПоУмолчанию) Тогда
			ЗначениеПоказателя = Неопределено;
			Если НЕ ПустаяСтрока(Стр.Ключ) И НЕ ПустаяСтрока(Стр.Раздел) Тогда
				Если ПараметрыСтраницы.Свойство(Стр.Ключ, ЗначениеПоказателя) Тогда 
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
				Иначе
					РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, "");
				КонецЕсли;
			ИначеЕсли НЕ ПустаяСтрока(Стр.Код) И ПараметрыСтраницы.Свойство(Стр.Код, ЗначениеПоказателя) И ЗначениеЗаполнено(ЗначениеПоказателя) Тогда 
				РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, ЗначениеПоказателя);
			КонецЕсли;
		КонецЕсли;
		
		Если (Стр.Тип = "С" ИЛИ Стр.Тип = "C") Тогда 
			
			Если Стр.Многострочность = Истина Тогда 
				МногострочнаяЧасть = Неопределено;
				Если ПараметрыВыгрузки.ДанныеДопСтрокБД.Свойство(Стр.Код, МногострочнаяЧасть) Тогда
					МногострочнаяЧастьСтроки = МногострочнаяЧасть.НайтиСтроки(Новый Структура("УИД", ПараметрыСтраницы.УИД));
					Для Каждого Строка Из МногострочнаяЧастьСтроки Цикл 
						НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
						ЗаполнитьСтроки(ПараметрыВыгрузки, ПараметрыСтраницы, НовУзел, Строка);
					КонецЦикла;
				КонецЕсли;
			ИначеЕсли Стр.Многостраничность = Истина Тогда 
				МногостраничнаяЧасть = Неопределено;
				Если ПараметрыВыгрузки.ДанныеМногостраничныхРазделов.Свойство(Стр.Раздел, МногостраничнаяЧасть) Тогда 
					Для Каждого СтрМнгч Из МногостраничнаяЧасть Цикл 
						Если СтрМнгч.Значение.УИДРодителя = УИДРодителя Тогда 
							НовУзел = Документы.УведомлениеОСпецрежимахНалогообложения.НовыйУзелИзПрототипа(Стр);
							ЗаполнитьДаннымиСтраницу(ПараметрыВыгрузки, СтрМнгч.Значение, НовУзел, СтрМнгч.Значение.УИД);
						КонецЕсли;
					КонецЦикла;
				КонецЕсли;
			Иначе
				ЗаполнитьДаннымиСтраницу(ПараметрыВыгрузки, ПараметрыСтраницы, Стр, УИДРодителя);
			КонецЕсли;
			
		КонецЕсли;
		
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьСтроки(ПараметрыВыгрузки, ПараметрыСтраницы, Узел, Строка)
	Колонки = Строка.Владелец().Колонки;
	Для Каждого Стр из Узел.Строки Цикл
		Если Колонки.Найти(Стр.Код) <> Неопределено Тогда
			РегламентированнаяОтчетность.ВывестиПоказательСтатистикиВXML(Стр, Строка[Стр.Код]);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Процедура ЗаполнитьДаннымиПриложенныхДокументов(Объект, Параметры, ДеревоВыгрузки)
	Документы.УведомлениеОСпецрежимахНалогообложения.ОбработатьУсловныеЭлементы(Параметры, ДеревоВыгрузки);
	Документы.УведомлениеОСпецрежимахНалогообложения.ЗаполнитьПараметры(Параметры, ДеревоВыгрузки);
	
	Данные = Объект.ДанныеУведомления.Получить();
	
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(ДеревоВыгрузки, "DATA_PACKET_NI");
	Узел_Документ = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "ORG_INFO");
	
	Узел_Разрешения = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "WASTE_DOC");
	Узел_Вода = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "WATER_DOC");
	Узел_Атмосфера = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьПодчиненныйЭлемент(Узел_Документ, "EMISSION_DOC");
	
	Атмосфера = Данные.ДанныеЛицензий.НайтиСтроки(Новый Структура("Тип", 0));
	Вода = Данные.ДанныеЛицензий.НайтиСтроки(Новый Структура("Тип", 1));
	Разрешения = Данные.ДанныеЛицензий.НайтиСтроки(Новый Структура("Тип", 2));
	МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
	
	Для Каждого Стр Из Атмосфера Цикл
		ЗаполнитьУзел(Узел_Атмосфера, Стр, "ID_ED", МодульРаботаСФайлами);
	КонецЦикла;
	
	Для Каждого Стр Из Вода Цикл
		ЗаполнитьУзел(Узел_Вода, Стр, "ID_WD", МодульРаботаСФайлами);
	КонецЦикла;
	
	Для Каждого Стр Из Разрешения Цикл
		ЗаполнитьУзел(Узел_Разрешения, Стр, "ID_WSD", МодульРаботаСФайлами);
	КонецЦикла;
	
	РегламентированнаяОтчетность.УдалитьУзел(Узел_Атмосфера);
	РегламентированнаяОтчетность.УдалитьУзел(Узел_Вода);
	РегламентированнаяОтчетность.УдалитьУзел(Узел_Разрешения);
КонецПроцедуры

Процедура КонвертацияПостановкиНВОС(Ссылка) Экспорт
	Попытка
		СтруктураПараметров = Ссылка.ДанныеУведомления.Получить();
		ДанныеЛицензий = СтруктураПараметров.ДанныеЛицензий;
		Если ДанныеЛицензий.Колонки.Найти("ПрисоединенныйФайл") <> Неопределено Тогда 
			Возврат;
		КонецЕсли;
		
		НачатьТранзакцию();
		ДокОбъект = Ссылка.ПолучитьОбъект();
		МодульРаботаСФайлами = ОбщегоНазначения.ОбщийМодуль("РаботаСФайлами");
		Для Каждого Стр Из ДанныеЛицензий Цикл
			Если Не ЗначениеЗаполнено(Стр.ИмяФайла) Или Стр.ДД = Неопределено Тогда 
				Продолжить;
			КонецЕсли;
			
			ИмяБезРасширения = Лев(Стр.ИмяФайла, СтрНайти(Стр.ИмяФайла, ".", НаправлениеПоиска.СКонца) - 1);
			ПараметрыФайла = Новый Структура;
			ПараметрыФайла.Вставить("ВладелецФайлов", Ссылка);
			ПараметрыФайла.Вставить("Автор", Неопределено);
			ПараметрыФайла.Вставить("ИмяБезРасширения", СтрЗаменить(Строка(Новый УникальныйИдентификатор), "-", ""));
			ПараметрыФайла.Вставить("РасширениеБезТочки", Неопределено);
			ПараметрыФайла.Вставить("ВремяИзменения", Неопределено);
			ПараметрыФайла.Вставить("ВремяИзмененияУниверсальное", Неопределено);
			Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.РаботаСФайлами") Тогда 
				Стр.ПрисоединенныйФайл = МодульРаботаСФайлами.ДобавитьФайл(ПараметрыФайла, Стр.ДД, , "Файл создан автоматически из формы уведомления, редактирование запрещено.");
			КонецЕсли;
		КонецЦикла;
		
		ДанныеЛицензий.Колонки.Удалить("ДД");
		СтруктураПараметров.ДанныеЛицензий = ДанныеЛицензий;
		ДокОбъект.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
		
		ДокОбъект.Записать();
		ЗафиксироватьТранзакцию();
	Исключение
		ОтменитьТранзакцию();
		ЗаписьЖурналаРегистрации(
			НСтр("ru = 'Регламентированная отчетность. Обработка обновления. Преобразование конвертация уведомлений НВОС'", ОбщегоНазначения.КодОсновногоЯзыка()),
			УровеньЖурналаРегистрации.Ошибка,,, ПодробноеПредставлениеОшибки(ИнформацияОбОшибке()));
	КонецПопытки;
КонецПроцедуры
#КонецОбласти
#КонецЕсли
