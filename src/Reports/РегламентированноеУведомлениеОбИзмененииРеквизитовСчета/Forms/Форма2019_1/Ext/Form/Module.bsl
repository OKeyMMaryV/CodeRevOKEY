﻿&НаКлиенте
Перем ЦФЖ;

&НаКлиенте
Перем ЦФБ;

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)

	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПриЧтенииНаСервере(ЭтотОбъект, ТекущийОбъект);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом

КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	// СтандартныеПодсистемы.УправлениеДоступом
	Если ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.УправлениеДоступом") Тогда
		МодульУправлениеДоступом = ОбщегоНазначения.ОбщийМодуль("УправлениеДоступом");
		МодульУправлениеДоступом.ПослеЗаписиНаСервере(ЭтотОбъект, ТекущийОбъект, ПараметрыЗаписи);
	КонецЕсли;
	// Конец СтандартныеПодсистемы.УправлениеДоступом
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;

	Данные = Неопределено;
	Параметры.Свойство("Данные", Данные);
	
	Объект.ВидУведомления = Перечисления.ВидыУведомленийОСпецрежимахНалогообложения.УведомлениеОбИзмененииРеквизитовСчета;
	УведомлениеОСпецрежимахНалогообложения.НачальныеОперацииПриСозданииНаСервере(ЭтотОбъект);
	УведомлениеОСпецрежимахНалогообложения.СформироватьСпискиВыбора(ЭтотОбъект, "СпискиВыбора2019_1");
	РазделительНомераСтроки = "___";
	
	Если ТипЗнч(Данные) = Тип("Структура") Тогда
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		УведомлениеОСпецрежимахНалогообложения.ЗагрузитьДанныеПростогоУведомления(ЭтотОбъект, Данные, ПредставлениеУведомления)
	ИначеЕсли Параметры.Свойство("Ключ") И ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Организация = Параметры.Ключ.Организация;
		ЗагрузитьДанные(Параметры.Ключ);
	ИначеЕсли Параметры.Свойство("ЗначениеКопирования") И ЗначениеЗаполнено(Параметры.ЗначениеКопирования) Тогда
		Объект.Организация = Параметры.ЗначениеКопирования.Организация;
		ЗагрузитьДанные(Параметры.ЗначениеКопирования);
	Иначе
		Параметры.Свойство("Организация", Объект.Организация);
		Объект.РегистрацияВИФНС = Документы.УведомлениеОСпецрежимахНалогообложения.РегистрацияВФНСОрганизации(Объект.Организация);
		СформироватьДеревоСтраниц();
		УведомлениеОСпецрежимахНалогообложения.СформироватьСтруктуруДанныхУведомленияНовогоОбразца(ЭтотОбъект);
		ЗаполнитьНачальныеДанные();
	КонецЕсли;
	
	РегламентированнаяОтчетностьКлиентСервер.ПриИнициализацииФормыРегламентированногоОтчета(ЭтотОбъект);
	Заголовок = Заголовок + " (" + ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.Организация, "НаименованиеСокращенное") + ")";
	ДоступнаПодсистемаВалюты = ОбщегоНазначения.ПодсистемаСуществует("СтандартныеПодсистемы.Валюты");
	ЭтоЮЛ = РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация);
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	Если ЗавершениеРаботы Тогда
		Возврат;
	КонецЕсли;
	
	Если Модифицированность Тогда
		ПриЗакрытииНаСервере();
	КонецЕсли;
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	РегламентированнаяОтчетностьКлиент.ПередЗакрытиемРегламентированногоОтчета(ЭтаФорма, Отказ, СтандартнаяОбработка, ЗавершениеРаботы, ТекстПредупреждения);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ЦФЖ = Новый Цвет(255, 255, 192);
	ЦФБ = Новый Цвет(255, 255, 255);
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	ДоступностьОбластиКоррФайл();
КонецПроцедуры

#КонецОбласти

&НаСервере
Процедура ЗаполнитьНачальныеДанные()
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("КодНО", ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Объект.РегистрацияВИФНС, "Код"));
	Объект.ДатаПодписи = ТекущаяДатаСеанса();
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", Объект.ДатаПодписи);
	
	Если РегламентированнаяОтчетностьПереопределяемый.ЭтоЮридическоеЛицо(Объект.Организация) Тогда
		СтрокаСведений = "ИННЮЛ,НаимЮЛПол,КППЮЛ,ТелОрганизации";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННЮЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.НаимЮЛПол);
		ДанныеУведомленияТитульный.Вставить("КПП", СведенияОбОрганизации.КППЮЛ);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелОрганизации);
	Иначе
		СтрокаСведений = "ИННФЛ,ФИО,ТелДом";
		СведенияОбОрганизации = РегламентированнаяОтчетностьВызовСервера.ПолучитьСведенияОбОрганизации(Объект.Организация, Объект.ДатаПодписи, СтрокаСведений);
		ДанныеУведомленияТитульный.Вставить("ИНН", СведенияОбОрганизации.ИННФЛ);
		ДанныеУведомленияТитульный.Вставить("Наименование", СведенияОбОрганизации.ФИО);
		ДанныеУведомленияТитульный.Вставить("Тлф", СведенияОбОрганизации.ТелДом);
	КонецЕсли;
	
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ДанныеУведомленияТитульный.Вставить("КодНО", Реквизиты.Код);
	ДанныеУведомленияТитульный.Вставить("КПП", Реквизиты.КПП);
	
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "2");
		ДанныеУведомленияТитульный.Вставить("НаимДок", Реквизиты.ДокументПредставителя);
	Иначе
		УстановитьПредставителяПоОрганизации();
		ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", "1");
		ДанныеУведомленияТитульный.Вставить("НаимДок", "");
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СформироватьДеревоСтраниц()
	ДеревоСтраниц.ПолучитьЭлементы().Очистить();
	КорневойУровень = ДеревоСтраниц.ПолучитьЭлементы();
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Титульная страница";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Титульная_2019";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Ложь;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Титульная";
	Стр001.МакетыПФ = "Печать_Форма2019_1_Титульная";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения после изменений";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист1_2019";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист001";
	Стр001.МногострочныеЧасти.Добавить("МнгСтр1");
	Стр001.МакетыПФ = "Печать_Форма2019_1_Лист001";
	
	Стр001 = КорневойУровень.Добавить();
	Стр001.Наименование = "Сведения до изменений";
	Стр001.ИндексКартинки = 1;
	Стр001.ИмяМакета = "Лист2_2019";
	Стр001.Многостраничность = Ложь;
	Стр001.Многострочность = Истина;
	Стр001.УИД = Новый УникальныйИдентификатор;
	Стр001.ИДНаименования = "Лист002";
	Стр001.МногострочныеЧасти.Добавить("МнгСтр2");
	Стр001.МакетыПФ = "Печать_Форма2019_1_Лист001";
КонецПроцедуры

&НаКлиенте
Процедура ДеревоСтраницПриАктивизацииСтроки(Элемент)
	Если УИДТекущаяСтраница <> Элемент.ТекущиеДанные.УИД Тогда 
		Если ТекущееИДНаименования = "Лист001" Или ТекущееИДНаименования = "Лист002" Тогда 
			СобратьДанныеМногострочныхЧастейТекущейСтраницы();
		КонецЕсли;
		ПредУИД = УИДТекущаяСтраница;
		
		УИДТекущаяСтраница = Элемент.ТекущиеДанные.УИД;
		ТекущееИДНаименования = Элемент.ТекущиеДанные.ИДНаименования;
		Если Не ЗначениеЗаполнено(ТекущееИДНаименования) Тогда 
			ТекущееИДНаименования = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].ИДНаименования;
			УИДТекущаяСтраница = Элемент.ТекущиеДанные.ПолучитьЭлементы()[0].УИД;
		КонецЕсли;
		
		ПоказатьТекущуюСтраницу(Элемент.ТекущиеДанные.ИмяМакета);
		ДоступностьОбластиКоррФайл();
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ДоступностьОбластиКоррФайл()
	Если ТекущееИДНаименования = "Титульная" Тогда
		ОФ = ПредставлениеУведомления.Области.Найти("ИдФайлКорр");
		ОФ.ЦветФона = ?(ЗначениеЗаполнено(ПредставлениеУведомления.Области.НомКорр.Значение), ЦФЖ, ЦФБ);
		ОФ.АвтоОтметкаНезаполненного = ЗначениеЗаполнено(ПредставлениеУведомления.Области.НомКорр.Значение);
		ОФ.Защита = Не ЗначениеЗаполнено(ПредставлениеУведомления.Области.НомКорр.Значение);
		ОФ.Значение = ?(ЗначениеЗаполнено(ПредставлениеУведомления.Области.НомКорр.Значение), ОФ.Значение, "");
		
		ОФ = ПредставлениеУведомления.Области.Найти("Наименование");
		ОФ.ЦветФона = ?(ЭтоЮЛ, ЦФЖ, ЦФБ);
		ОФ.АвтоОтметкаНезаполненного = ЭтоЮЛ;
		ОФ.Защита = Не ЭтоЮЛ;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПоказатьТекущуюСтраницу(ИмяМакета)
	ПредставлениеУведомления.Очистить();
	ТекущийМакет = ИмяМакета;
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ИмяМакета);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("ОсновнаяЧасть"));
	СтрДанных = ДанныеУведомления[ТекущееИДНаименования];
	Для Каждого Обл Из ПредставлениеУведомления.Области Цикл 
		Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник
			И Обл.СодержитЗначение Тогда 
			
			СтрДанных.Свойство(Обл.Имя, Обл.Значение);
		КонецЕсли;
	КонецЦикла;
	
	Если ТекущееИДНаименования = "Лист001" Или ТекущееИДНаименования = "Лист002"  Тогда 
		ПоказатьМногострочныеЧасти();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СобратьДанныеМногострочныхЧастейТекущейСтраницы()
	Если ТекущееИДНаименования = "Лист001" Тогда 
		МнгСтр = "МнгСтр1";
	ИначеЕсли ТекущееИДНаименования = "Лист002" Тогда 
		МнгСтр = "МнгСтр2";
	Иначе
		Возврат;
	КонецЕсли;
	
	ВсеДопСтроки = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгСтр]);
	ВсеДопСтроки.Очистить();
	
	Инд = 0;
	Пока Истина Цикл 
		Инд = Инд + 1;
		Обл = ПредставлениеУведомления.Области.Найти("КодВалСчет" + РазделительНомераСтроки + Формат(Инд, "ЧГ=0"));
		Если Обл = Неопределено Тогда 
			Прервать;
		КонецЕсли;
		НовСтр = ВсеДопСтроки.Добавить();
		НовСтр.КодВалСчет = Обл.Значение;
	КонецЦикла;
	
	ДанныеДопСтрок[МнгСтр] = ПоместитьВоВременноеХранилище(ВсеДопСтроки, ДанныеДопСтрок[МнгСтр]);
КонецПроцедуры

&НаКлиенте
Функция ОпределитьПринадлежностьОбластиКМногострочномуРазделу(ОбластьИмя) Экспорт 
КонецФункции

&НаСервере
Процедура ПоказатьМногострочныеЧасти()
	Если ТекущееИДНаименования = "Лист001" Тогда 
		МнгСтр = "МнгСтр1";
	ИначеЕсли ТекущееИДНаименования = "Лист002" Тогда 
		МнгСтр = "МнгСтр2";
	Иначе
		Возврат;
	КонецЕсли;
	
	Макет = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ТекущийМакет);
	ТЗ = ПолучитьИзВременногоХранилища(ДанныеДопСтрок[МнгСтр]);
	Если ТЗ.Количество() = 0 Тогда 
		ТЗ.Добавить();
	КонецЕсли;
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Header_" + МнгСтр));
	Инд = 0;
	ВыводитьЗначокУдаления = (ТЗ.Количество() > 1);
	Для Каждого Стр Из ТЗ Цикл
		Инд = Инд + 1;
		ИндСтр = РазделительНомераСтроки + Формат(Инд, "ЧГ=");
		Обл = Макет.ПолучитьОбласть("Str_" + МнгСтр);
		ОблПодч = Обл.Области.Найти("КодВалСчет");
		ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
		ОблПодч.Значение = Стр.КодВалСчет;
		
		ОблПодч = Обл.Области.Найти("Del_" + МнгСтр);
		ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
		Если ВыводитьЗначокУдаления Тогда 
			ОблПодч.Текст = "х";
			ОблПодч.Гиперссылка = Истина;
		КонецЕсли;
		ПредставлениеУведомления.Вывести(Обл);
	КонецЦикла;
	
	ОблДобавленияСтроки = Документы.УведомлениеОСпецрежимахНалогообложения.ПолучитьМакет("ОбщиеЭлементы").ПолучитьОбласть("AddStrArea");
	ОблДобавленияСтроки.Области["AddStrLabel"].Имя = "AddStrLabel_" + МнгСтр;
	ОблДобавленияСтроки.Области["AddStr"].Имя = "AddStr_" + МнгСтр;
	ПредставлениеУведомления.Вывести(ОблДобавленияСтроки);
	ПредставлениеУведомления.Вывести(Макет.ПолучитьОбласть("Footer_" + МнгСтр));
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элемент, Область)
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область);
	
	Если Область.Имя = "ДАТА_ПОДПИСИ" Тогда
		Объект.ДатаПодписи = Область.Значение;
		УстановитьДанныеПоРегистрацииВИФНС();
	ИначеЕсли Область.Имя = "НомКорр" Тогда
		ДоступностьОбластиКоррФайл();
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьДанныеПоРегистрацииВИФНС()
	Реквизиты = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Объект.РегистрацияВИФНС, "Код,Представитель,КПП,ДокументПредставителя");
	ПредставлениеУведомления.Области["КодНО"].Значение = Реквизиты.Код;
	ПредставлениеУведомления.Области["КПП"].Значение = Реквизиты.КПП;
	Если ЗначениеЗаполнено(Реквизиты.Представитель) Тогда
		УстановитьПредставителяПоФизЛицу(Реквизиты.Представитель);
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "2";
		ПредставлениеУведомления.Области["НаимДок"].Значение = Реквизиты.ДокументПредставителя;
	Иначе
		УстановитьПредставителяПоОрганизации();
		ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение = "1";
		ПредставлениеУведомления.Области["НаимДок"].Значение = "";
	КонецЕсли;
	
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ДанныеУведомленияТитульный.Вставить("ПРИЗНАК_НП_ПОДВАЛ", ПредставлениеУведомления.Области["ПРИЗНАК_НП_ПОДВАЛ"].Значение);
	ДанныеУведомленияТитульный.Вставить("НаимДок", ПредставлениеУведомления.Области["НаимДок"].Значение);
	ДанныеУведомленияТитульный.Вставить("ДАТА_ПОДПИСИ", ПредставлениеУведомления.Области["ДАТА_ПОДПИСИ"].Значение);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение);
	ДанныеУведомленияТитульный.Вставить("КодНО", ПредставлениеУведомления.Области["КодНО"].Значение);
	ДанныеУведомленияТитульный.Вставить("КПП", ПредставлениеУведомления.Области["КПП"].Значение);
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоФизЛицу(Физлицо)
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	Если ЗначениеЗаполнено(Физлицо) Тогда 
		ДанныеПредставителя = РегламентированнаяОтчетностьПереопределяемый.ПолучитьСведенияОФизЛице(Физлицо, , Объект.ДатаПодписи);
		Объект.ПодписантФамилия = СокрЛП(ДанныеПредставителя.Фамилия);
		Объект.ПодписантИмя = СокрЛП(ДанныеПредставителя.Имя);
		Объект.ПодписантОтчество = СокрЛП(ДанныеПредставителя.Отчество);
		ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
		КонецЕсли;
	Иначе
		Объект.ПодписантФамилия = "";
		Объект.ПодписантИмя = "";
		Объект.ПодписантОтчество = "";
		ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", "");
		Если ЕстьОбласть Тогда 
			ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = "";
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура УстановитьПредставителяПоОрганизации()
	ДанныеУведомленияТитульный = ДанныеУведомления["Титульная"];
	ЕстьОбласть = (Неопределено <> ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"));
	ПодписантСтр = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
	ДанныеУведомленияТитульный.Вставить("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ПодписантСтр);
	Если ЕстьОбласть Тогда 
		ПредставлениеУведомления.Области["ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ"].Значение = ПодписантСтр;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура СохранитьДанные() Экспорт
	Если ЗначениеЗаполнено(Объект.Ссылка) И Не Модифицированность Тогда 
		Возврат;
	КонецЕсли;
	Если ТекущееИДНаименования = "Лист001" Или ТекущееИДНаименования = "Лист002" Тогда 
		СобратьДанныеМногострочныхЧастейТекущейСтраницы();
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(Объект.Ссылка) Тогда
		Объект.Дата = ТекущаяДатаСеанса() 
	КонецЕсли;
	
	ДанныеДопСтрокБД = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрок Цикл 
		ДанныеДопСтрокБД.Вставить(КЗ.Ключ, ПолучитьИзВременногоХранилища(КЗ.Значение));
	КонецЦикла;
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	СтруктураПараметров.Вставить("ДанныеДопСтрокБД", ДанныеДопСтрокБД);
	СтруктураПараметров.Вставить("ДеревоСтраниц", РеквизитФормыВЗначение("ДеревоСтраниц"));
	СтруктураПараметров.Вставить("ДанныеУведомления", ДанныеУведомления);
	СтруктураПараметров.Вставить("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	
	Документ = РеквизитФормыВЗначение("Объект");
	Документ.ДанныеУведомления = Новый ХранилищеЗначения(СтруктураПараметров);
	Документ.Записать();
	ЗначениеВДанныеФормы(Документ, Объект);
	Модифицированность = Ложь;
	ЭтотОбъект.Заголовок = СтрЗаменить(ЭтотОбъект.Заголовок, " (создание)", "");
	
	УведомлениеОСпецрежимахНалогообложения.СохранитьНастройкиРучногоВвода(ЭтотОбъект);
	РегламентированнаяОтчетность.СохранитьСтатусОтправкиУведомления(ЭтаФорма);
КонецПроцедуры

&НаКлиенте
Процедура Сохранить(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьДанные(СсылкаНаДанные)
	СтруктураПараметров = СсылкаНаДанные.Ссылка.ДанныеУведомления.Получить();
	ДанныеУведомления = СтруктураПараметров.ДанныеУведомления;
	ЗначениеВРеквизитФормы(СтруктураПараметров.ДеревоСтраниц, "ДеревоСтраниц");
	СтруктураПараметров.Свойство("РазрешитьВыгружатьСОшибками", РазрешитьВыгружатьСОшибками);
	СтруктураПараметров.Свойство("ИдентификаторыОбычныхСтраниц", ИдентификаторыОбычныхСтраниц);
	
	ДанныеДопСтрокБД = СтруктураПараметров.ДанныеДопСтрокБД;
	ДанныеДопСтрок = Новый Структура;
	ДанныеДопСтрокСтраницы = Новый Структура;
	Для Каждого КЗ Из ДанныеДопСтрокБД Цикл 
		ДанныеДопСтрок.Вставить(КЗ.Ключ, ПоместитьВоВременноеХранилище(КЗ.Значение, Новый УникальныйИдентификатор));
		Стр = Новый Структура;
		Для Каждого Кол Из КЗ.Значение.Колонки Цикл 
			Если Кол.Имя <> "УИД" Тогда 
				Стр.Вставить(Кол.Имя);
			КонецЕсли;
		КонецЦикла;
		СЗ = Новый СписокЗначений;
		Для Каждого СтрТЗ Из КЗ.Значение Цикл 
			ЗаполнитьЗначенияСвойств(Стр, СтрТЗ);
			СЗ.Добавить(ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(Стр));
		КонецЦикла;
		Если СЗ.Количество() = 0 Тогда 
			СЗ.Добавить(Стр);
		КонецЕсли;
		ДанныеДопСтрокСтраницы.Вставить(КЗ.Ключ, СЗ);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияВыбор(Элемент, Область, СтандартнаяОбработка)
	Если СтрНачинаетсяС(Область.Имя, "AddStr_") Или СтрНачинаетсяС(Область.Имя, "AddStrLabel_") Тогда
		ДобавитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	ИначеЕсли СтрНачинаетсяС(Область.Имя, "Del_") И Область.Гиперссылка = Истина Тогда
		УдалитьСтроку(Область.Имя);
		СтандартнаяОбработка = Ложь;
		Модифицированность = Истина;
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка И Область.Имя = "ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ" Тогда 
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораПодписантаЗавершение", ЭтотОбъект, Неопределено);
		РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораФИО(ЭтотОбъект, СтандартнаяОбработка, "ПредставлениеУведомления",
																	"ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ", ОписаниеОповещения);
		Возврат;
	КонецЕсли;
	
	Если РучнойВвод Тогда 
		Возврат;
	КонецЕсли;
	
	Если СтандартнаяОбработка Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПредставлениеУведомленияВыбор(ЭтотОбъект, Область, СтандартнаяОбработка);
	КонецЕсли;
	
	Если Область.Имя = "КодНО" Тогда 
		СтандартнаяОбработка = Ложь;
		ОбработкаКодаНО(Область.Имя);
	КонецЕсли;
	
	Если СтандартнаяОбработка И ЭтоОбластьОКСМ(Область) Тогда
		СтандартнаяОбработка = Ложь;
		ДополнительныеПараметры = Новый Структура("Область, СтандартнаяОбработка, Элемент", Область, СтандартнаяОбработка, Элемент);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораСтраныЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("Справочник.СтраныМира.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	ИначеЕсли ДоступнаПодсистемаВалюты И СтандартнаяОбработка И ЭтоОбластьВалюта(Область) Тогда
		СтандартнаяОбработка = Ложь;
		ДополнительныеПараметры = Новый Структура("Область, СтандартнаяОбработка, Элемент", Область, СтандартнаяОбработка, Элемент);
		ОписаниеОповещения = Новый ОписаниеОповещения("ОткрытьФормуВыбораВалютыЗавершение", ЭтотОбъект, ДополнительныеПараметры);
		ОткрытьФорму("Справочник.Валюты.ФормаВыбора", Новый Структура("РежимВыбора", Истина), ЭтотОбъект,,,,ОписаниеОповещения,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораВалютыЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		Инфо = ИнформацияПоВалюте(Результат);
		Обл = ДополнительныеПараметры.Область;
		Обл.Значение = Инфо.Код;
		ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элементы.ПредставлениеУведомления, Обл);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция ИнформацияПоВалюте(Результат)
	Возврат ОбщегоНазначения.ЗначенияРеквизитовОбъекта(Результат, "Код, Наименование");
КонецФункции

&НаСервере
Процедура ДобавитьСтроку(ИмяОбласти)
	ИмяОбласти = СтрЗаменить(ИмяОбласти, "AddStr_", "");
	ИмяОбласти = СтрЗаменить(ИмяОбласти, "AddStrLabel_", "");
	
	ДопСтрокиТекущейСтраницы = ДанныеДопСтрокСтраницы[ИмяОбласти];
	НомерДобавляемойСтроки = ДопСтрокиТекущейСтраницы.Количество() + 1;
	НоваяСтрока = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(ДанныеДопСтрокСтраницы[ИмяОбласти][0].Значение);
	Для Каждого КЗ Из НоваяСтрока Цикл 
		НоваяСтрока[КЗ.Ключ] = Неопределено;
	КонецЦикла;
	ДопСтрокиТекущейСтраницы.Добавить(НоваяСтрока);
	Верх = ПредставлениеУведомления.Области[КЗ.Ключ + РазделительНомераСтроки + Формат(НомерДобавляемойСтроки - 1, "ЧГ=0")].Верх + 1;
	Обл = Отчеты[Объект.ИмяОтчета].ПолучитьМакет(ТекущийМакет).ПолучитьОбласть("Str_" + ИмяОбласти);
	ИндСтр = РазделительНомераСтроки + Формат(НомерДобавляемойСтроки, "ЧГ=0");
	Для Каждого ОблПодч Из Обл.Области Цикл 
		Если ОблПодч.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
			ОблПодч.Имя = ОблПодч.Имя + ИндСтр;
		КонецЕсли;
	КонецЦикла;
	ПредставлениеУведомления.ВставитьОбласть(Обл.Область(), ПредставлениеУведомления.Область(Верх,,Верх,), ТипСмещенияТабличногоДокумента.ПоВертикали);
	ПредставлениеУведомления.Области["Str_" + ИмяОбласти].Имя = "";
	Для Инд = 1 По НомерДобавляемойСтроки Цикл 
		ОблПодч = ПредставлениеУведомления.Области["Del_" + ИмяОбласти + РазделительНомераСтроки + Формат(Инд, "ЧГ=0")];
		ОблПодч.Текст = "х";
		ОблПодч.Гиперссылка = Истина;
	КонецЦикла;
	
	Для Каждого КЗ Из ДопСтрокиТекущейСтраницы[НомерДобавляемойСтроки-1].Значение Цикл 
		Элементы.ПредставлениеУведомления.ТекущаяОбласть = ПредставлениеУведомления.Области.Найти(КЗ.Ключ + РазделительНомераСтроки + Формат(НомерДобавляемойСтроки, "ЧГ="));
		Прервать;
	КонецЦикла;
КонецПроцедуры

&НаСервере
Процедура УдалитьСтроку(ИмяОбласти)
	ОТЧ = Новый ОписаниеТипов("Число");
	Разложение = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(СтрЗаменить(ИмяОбласти, "Del_", ""), РазделительНомераСтроки);
	ДопСтроки = Разложение[0];
	Номер = ОТЧ.ПривестиЗначение(Разложение[1]);
	ДанныеДопСтрокСтраницы[ДопСтроки].Удалить(Номер-1);
	Верх = ПредставлениеУведомления.Области[ИмяОбласти].Верх;
	ПредставлениеУведомления.УдалитьОбласть(ПредставлениеУведомления.Область(Верх,,Верх), ТипСмещенияТабличногоДокумента.ПоВертикали);
	Низ = Верх + ДанныеДопСтрокСтраницы[ДопСтроки].Количество() - Номер;
	
	Если Низ >= Верх Тогда 
		Области = ПредставлениеУведомления.ПолучитьОбласть(Верх,,Низ).Области;
		СоответствиеИмен = Новый Соответствие;
		Для Каждого Обл Из Области Цикл 
			Если Обл.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда
				П = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Обл.Имя, РазделительНомераСтроки);
				Если П.Количество() = 2 Тогда 
					СоответствиеИмен[Обл.Имя] = П[0] + РазделительНомераСтроки + Формат(ОТЧ.ПривестиЗначение(П[1]) - 1, "ЧГ=0");
				КонецЕсли;
			КонецЕсли;
		КонецЦикла;
		
		Пока Истина Цикл 
			Если СоответствиеИмен.Количество() = 0 Тогда 
				Прервать;
			КонецЕсли;
			
			Для Каждого КЗ Из СоответствиеИмен Цикл 
				Если СоответствиеИмен[КЗ.Значение] <> Неопределено Тогда 
					Продолжить;
				КонецЕсли;
				
				ПредставлениеУведомления.Области[КЗ.Ключ].Имя = КЗ.Значение;
				СоответствиеИмен.Удалить(КЗ.Ключ);
				Прервать;
			КонецЦикла;
		КонецЦикла;
	КонецЕсли;
	
	Если ДанныеДопСтрокСтраницы[ДопСтроки].Количество() = 1 Тогда
		ОблПодч = ПредставлениеУведомления.Области["Del_" + Разложение[0] + РазделительНомераСтроки + "1"];
		ОблПодч.Текст = "";
		ОблПодч.Гиперссылка = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Функция ЭтоОбластьОКСМ(Область)
	Возврат (Область.Имя = "КодСтр" И (ТекущееИДНаименования = "Лист001" Или ТекущееИДНаименования = "Лист002"));
КонецФункции

&НаКлиенте
Функция ЭтоОбластьВалюта(Область)
	Возврат (СтрНачинаетсяС(Область.Имя, "КодВалСчет___"));
КонецФункции

&НаКлиенте
Процедура ОбработкаКодаНО(Инфо)
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуВыбораРегистрацииВИФНС(ЭтотОбъект, Инфо);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаКодаНОЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Инфо = ДополнительныеПараметры.Инфо;
	
	Если Результат <> Неопределено Тогда 
		Объект.РегистрацияВИФНС = Результат;
		УстановитьДанныеПоРегистрацииВИФНС();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораПодписантаЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если ТипЗнч(Результат) = Тип("Структура") Тогда
		Результат.Свойство("Фамилия", Объект.ПодписантФамилия);
		Результат.Свойство("Имя", Объект.ПодписантИмя);
		Результат.Свойство("Отчество", Объект.ПодписантОтчество);
		Представление = СокрЛП(Объект.ПодписантФамилия + " " + Объект.ПодписантИмя + " " + Объект.ПодписантОтчество);
		Область = ПредставлениеУведомления.Области.Найти("ФИО_РУКОВОДИТЕЛЯ_ПРЕДСТАВИТЕЛЯ");
		Область.Значение = Представление;
		УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, Область);
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗакрытииНаСервере()
	СохранитьДанные();
КонецПроцедуры

&НаСервере
Функция СформироватьXMLНаСервере(УникальныйИдентификатор)
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ВыгрузитьДокумент(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура СформироватьXML(Команда)
	ВыгружаемыеДанные = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если ВыгружаемыеДанные <> Неопределено Тогда 
		РегламентированнаяОтчетностьКлиент.ВыгрузитьФайлы(ВыгружаемыеДанные);
	Иначе
		ТекстВопроса = НСтр("ru='При выгрузке произошли ошибки. Открыть окно проверок контроля выгрузки?'");
		ОО = Новый ОписаниеОповещения("СформироватьXMLПриОшибке", ЭтотОбъект);
		ПоказатьВопрос(ОО, ТекстВопроса, РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура СформироватьXMLПриОшибке(Знач Результат, Знач ПараметрКоманды) Экспорт
	Если Результат = КодВозвратаДиалога.Да Тогда
		ПроверитьВыгрузку(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения", ПараметрыЗаписи, Объект.Ссылка);
КонецПроцедуры

&НаКлиенте
Процедура ПоказатьСДвухмернымШтрихкодомPDF417(Команда)
	РегламентированнаяОтчетностьКлиент.ВывестиМашиночитаемуюФормуУведомленияОСпецрежимах(ЭтотОбъект);
КонецПроцедуры

&НаСервере
Функция СформироватьВыгрузкуИПолучитьДанные() Экспорт 
	Выгрузка = СформироватьXMLНаСервере(УникальныйИдентификатор);
	Если Выгрузка = Неопределено Тогда 
		Возврат Неопределено;
	КонецЕсли;
	Выгрузка = Выгрузка[0];
	Возврат Новый Структура("ТестВыгрузки,КодировкаВыгрузки,Данные,ИмяФайла", 
			Выгрузка.ТестВыгрузки, Выгрузка.КодировкаВыгрузки, 
			Отчеты[Объект.ИмяОтчета].ПолучитьМакет("TIFF_2019_1"),
			"1120107_5.04000_03.tif");
КонецФункции

&НаКлиенте
Процедура СохранитьНаКлиенте(Автосохранение = Ложь,ВыполняемоеОповещение = Неопределено) Экспорт 
	
	СохранитьДанные();
	Если ВыполняемоеОповещение <> Неопределено Тогда
		ВыполнитьОбработкуОповещения(ВыполняемоеОповещение);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьИЗакрыть(Команда)
	СохранитьДанные();
	Оповестить("Запись_УведомлениеОСпецрежимахНалогообложения",,Объект.Ссылка);
	Закрыть(Неопределено);
КонецПроцедуры

#Область ОтправкаВФНС
////////////////////////////////////////////////////////////////////////////////
// Отправка в ФНС
&НаКлиенте
Процедура ОтправитьВКонтролирующийОрган(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПриНажатииНаКнопкуОтправкиВКонтролирующийОрган(ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура ПроверитьВИнтернете(Команда)
	
	РегламентированнаяОтчетностьКлиент.ПроверитьВИнтернете(ЭтотОбъект);
	
КонецПроцедуры
#КонецОбласти

#Область ПанельОтправкиВКонтролирующиеОрганы

&НаКлиенте
Процедура ОбновитьОтправку(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОбновитьОтправкуИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаПротоколНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьПротоколИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ОтправитьНеотправленноеИзвещение(Команда)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОтправитьНеотправленноеИзвещениеИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ЭтапыОтправкиНажатие(Элемент)
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьСостояниеОтправкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура КритическиеОшибкиОбработкаНавигационнойСсылки(Элемент, НавигационнаяСсылкаФорматированнойСтроки, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ЭлектронныйДокументооборотСКонтролирующимиОрганамиКлиент.ОткрытьКритическиеОшибкиИзПанелиОтправки(ЭтотОбъект, "ФНС");
КонецПроцедуры

&НаКлиенте
Процедура ГиперссылкаНаименованиеЭтапаНажатие(Элемент)
	
	ПараметрыИзменения = Новый Структура;
	ПараметрыИзменения.Вставить("Форма", ЭтаФорма);
	ПараметрыИзменения.Вставить("Организация", Объект.Организация);
	ПараметрыИзменения.Вставить("КонтролирующийОрган",
		ПредопределенноеЗначение("Перечисление.ТипыКонтролирующихОрганов.ФНС"));
	ПараметрыИзменения.Вставить("ТекстВопроса", НСтр("ru='Вы уверены, что уведомление уже сдано?'"));
	
	РегламентированнаяОтчетностьКлиент.ИзменитьСтатусОтправки(ПараметрыИзменения);
	
КонецПроцедуры

#КонецОбласти

&НаСервере
Функция ПроверитьВыгрузкуНаСервере()
	СохранитьДанные();
	Документ = РеквизитФормыВЗначение("Объект");
	Возврат Документ.ПроверитьДокументСВыводомВТаблицу(УникальныйИдентификатор);
КонецФункции

&НаКлиенте
Процедура ПроверитьВыгрузку(Команда)
	ТаблицаОшибок = ПроверитьВыгрузкуНаСервере();
	Если ТаблицаОшибок.Количество() = 0 Тогда 
		ОбщегоНазначенияКлиент.СообщитьПользователю("Ошибок не обнаружено");
	Иначе
		ОткрытьФорму("Документ.УведомлениеОСпецрежимахНалогообложения.Форма.НавигацияПоОшибкам", Новый Структура("ТаблицаОшибок", ТаблицаОшибок), ЭтотОбъект, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОткрытьПрисоединенныеФайлы(Команда)
	
	РегламентированнаяОтчетностьКлиент.СохранитьУведомлениеИОткрытьФормуПрисоединенныеФайлы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПечатьБРО(Команда)
	ПечатьБРОНаСервере();
	РегламентированнаяОтчетностьКлиент.ОткрытьФормуПредварительногоПросмотра(ЭтотОбъект, , Ложь, СтруктураРеквизитовУведомления.СписокПечатаемыхЛистов);
КонецПроцедуры

&НаСервере
Процедура ПечатьБРОНаСервере()
	УведомлениеОСпецрежимахНалогообложения.ПечатьУведомленияБРО(ЭтотОбъект);
КонецПроцедуры

&НаКлиенте
Процедура РучнойВвод(Команда)
	РучнойВвод = Не РучнойВвод;
	Элементы.ФормаРучнойВвод.Пометка = РучнойВвод;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "УведомлениеОСпецрежимахНалогообложения_НавигацияПоОшибкам" Тогда 
		УведомлениеОСпецрежимахНалогообложенияКлиент.ОбработкаОповещенияНавигацииПоОшибкам(ЭтотОбъект, Параметр, Источник);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура РазрешитьВыгружатьСОшибками(Команда)
	РазрешитьВыгружатьСОшибками = Не РазрешитьВыгружатьСОшибками;
	Элементы.ФормаРазрешитьВыгружатьСОшибками.Пометка = РазрешитьВыгружатьСОшибками;
	Модифицированность = Истина;
КонецПроцедуры

&НаКлиенте
Процедура ПредставлениеУведомленияПриАктивизацииОбласти(Элемент)
	Если ПредставлениеУведомления.ТекущаяОбласть.ТипОбласти = ТипОбластиЯчеекТабличногоДокумента.Прямоугольник Тогда 
		Элементы.ПредставлениеУведомленияКонтекстноеМенюОчиститьОКСМ.Доступность = 
			ЭтоОбластьОКСМ(ПредставлениеУведомления.ТекущаяОбласть) Или ЭтоОбластьВалюта(ПредставлениеУведомления.ТекущаяОбласть);
	Иначе
		Элементы.ПредставлениеУведомленияКонтекстноеМенюОчиститьОКСМ.Доступность = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьОКСМ(Команда)
	ПредставлениеУведомления.ТекущаяОбласть.Значение = Неопределено;
	УведомлениеОСпецрежимахНалогообложенияКлиент.ПриИзмененииСодержимогоОбласти(ЭтотОбъект, ПредставлениеУведомления.ТекущаяОбласть);
КонецПроцедуры

&НаКлиенте
Процедура ОткрытьФормуВыбораСтраныЗавершение(Результат, ДополнительныеПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		КодЭлементаСправочника = КодЭлементаСправочника(Результат);
		Область = ДополнительныеПараметры.Область;
		Если Область.Значение <> КодЭлементаСправочника Тогда
			Область.Значение = КодЭлементаСправочника;
			Модифицированность = Истина;
		КонецЕсли;
		ПредставлениеУведомленияПриИзмененииСодержимогоОбласти(Элементы.ПредставлениеУведомления, Область);
	КонецЕсли;
КонецПроцедуры

&НаСервере
Функция КодЭлементаСправочника(Результат)
	Возврат ОбщегоНазначения.ЗначениеРеквизитаОбъекта(Результат, "Код");
КонецФункции
