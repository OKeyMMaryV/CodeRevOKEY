﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	// Стандартные действия при создании на сервере.
	бит_РаботаСДиалогамиСервер.ФормаОбъектаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтаФорма, Объект);
	
	фКэшЗначений = Новый Структура;
	
	МассивТипов  = Объект.Ссылка.Метаданные().ТабличныеЧасти.ПараметрыПрезентации.Реквизиты.ИсточникДанных.Тип.Типы();
	СписокВыбора = бит_ОбщегоНазначения.ПодготовитьСписокВыбораТипа(МассивТипов);
	
	фКэшЗначений.Вставить("СписокТиповИсточникДанных",СписокВыбора);
	
	
	СпрОб = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.бит_мпд_НастройкиПрезентацийОтчетности"));
	фЗагружен = СпрОб.МакетЗагружен();
	УправлениеЭлементамиФормы();
	
КонецПроцедуры // ПриСозданииНаСервере()

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ЭтоАдресВременногоХранилища(фАдресХранилищаМакета) Тогда
	
		ДанныеМакета = ПолучитьИзВременногоХранилища(фАдресХранилищаМакета);
		ТекущийОбъект.СохранитьМакет(ДанныеМакета);
		фЗагружен = ТекущийОбъект.МакетЗагружен();
	
	КонецЕсли; 
	фАдресХранилищаМакета = "";
	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СерииДиаграммДиаграммаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ТекущаяСтрока = Элементы.СерииДиаграмм.ТекущиеДанные;
	
	СписокВыбора = Новый СписокЗначений;
	
	Для каждого СтрокаТаблицы Из Объект.ДиаграммыПрезентации Цикл
		
		ПредставлениеДиаграммы = СтрокаТаблицы.КонтейнерПредставление +" "+ СтрокаТаблицы.Имя;
		СписокВыбора.Добавить(СтрокаТаблицы.ИД, ПредставлениеДиаграммы); 
	
	КонецЦикла; 
	
	ДопПараметры = Новый Структура("ТекущаяСтрока", ТекущаяСтрока);
	Оповещение = Новый ОписаниеОповещения("СерияВыборЗавершение", ЭтотОбъект, ДопПараметры);
	ПоказатьВыборИзСписка(Оповещение, СписокВыбора);
	
КонецПроцедуры

// Процедура обработчик оповещения "СерияВыборЗавершение".
// 
// Параметры:
// ВыбЭлемент - ЭлементСпискаЗначений
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура СерияВыборЗавершение(ВыбЭлемент, ДополнительныеДанные) Экспорт

	Если НЕ ВыбЭлемент = Неопределено Тогда
	
		ДополнительныеДанные.ТекущаяСтрока.ИдДиаграммы = ВыбЭлемент.Значение;
		ДополнительныеДанные.ТекущаяСтрока.Диаграмма = ВыбЭлемент.Представление;
	
	КонецЕсли; 
	
КонецПроцедуры	// СерияВыборЗавершение

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыПараметрыПрезентации

&НаКлиенте
Процедура ПараметрыПрезентацииИсточникДанныхПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ПараметрыПрезентации.ТекущиеДанные;
	ПараметрыПрезентацииИсточникДанныхПриИзмененииНаСервере(ТекущаяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура ПараметрыПрезентацииИсточникДанныхПриИзмененииНаСервере(ИдСтроки)
	
	ТекущаяСтрока = Объект.ПараметрыПрезентации.НайтиПоИдентификатору(ИдСтроки);
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		
		СписокРесурсов = СформироватьСписокРесурсов(ТекущаяСтрока.ИсточникДанных);
		
		Если ПустаяСтрока(ТекущаяСтрока.ИмяРесурса)  Тогда
			
			// Если ресурс один - можно сразу подставить.
			Если СписокРесурсов.Количество() = 1 Тогда
			
			  ТекущаяСтрока.ИмяРесурса = СписокРесурсов[0].Значение;
			
			КонецЕсли;
			
		Иначе
			
			// Проверка допустимости использования ресурсов.
			Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) 
				 И СписокРесурсов.НайтиПоЗначению(ТекущаяСтрока.ИмяРесурса) = Неопределено Тогда
				
				ТекстСообщения = НСтр("ru = 'Ресурс """"%1%"""" не используется в источнике данных """"%2%""""!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяСтрока.ИмяРесурса, ТекущаяСтрока.ИсточникДанных);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				ТекущаяСтрока.ИмяРесурса = "";
				
			КонецЕсли;
			
		КонецЕсли;                     
		
		// Текстовый маркер используется в условном оформлении.
		ТекущаяСтрока.ТипИсточникаДанных = ?(ТипЗнч(ТекущаяСтрока.ИсточникДанных) = Тип("СправочникСсылка.бит_СпособыКомпоновкиИсточниковДанных"),"СК","ИД");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрезентацииФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ОткрытьКонструкторФормата("ПараметрыПрезентации", "Формат");
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрезентацииИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ПараметрыПрезентации.ТекущиеДанные;
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,ТекущиеДанные
	                                                   ,"ИсточникДанных"
													   ,фКэшЗначений.СписокТиповИсточникДанных
													   ,СтандартнаяОбработка);
													   
	
	
КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрезентацииИсточникДанныхОчистка(Элемент, СтандартнаяОбработка)
		
	Элемент.ВыбиратьТип = Истина;

КонецПроцедуры

&НаКлиенте
Процедура ПараметрыПрезентацииИмяРесурсаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.ПараметрыПрезентации.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) Тогда
		
		СписокВыбора = СформироватьСписокРесурсов(ТекущаяСтрока.ИсточникДанных);
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
		
	КонецЕсли;	
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыСерииДиаграмм

&НаКлиенте
Процедура СерииДиаграммИсточникДанныхПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.СерииДиаграмм.ТекущиеДанные;
	СерииДиаграммИсточникДанныхПриИзмененииНаСервере(ТекущаяСтрока.ПолучитьИдентификатор());
	
КонецПроцедуры

&НаСервере
Процедура СерииДиаграммИсточникДанныхПриИзмененииНаСервере(ИдСтроки)
	
	ТекущаяСтрока = Объект.СерииДиаграмм.НайтиПоИдентификатору(ИдСтроки);
	Если НЕ ТекущаяСтрока = Неопределено Тогда
		
		СписокРесурсов = СформироватьСписокРесурсов(ТекущаяСтрока.ИсточникДанных);
		
		Если ПустаяСтрока(ТекущаяСтрока.ИмяРесурса)  Тогда
			
			// Если ресурс один - можно сразу подставить.
			Если СписокРесурсов.Количество() = 1 Тогда
			
			  ТекущаяСтрока.ИмяРесурса = СписокРесурсов[0].Значение;
			
			КонецЕсли;
			
		Иначе
			
			// Проверка допустимости использования ресурсов.
			Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) 
				 И СписокРесурсов.НайтиПоЗначению(ТекущаяСтрока.ИмяРесурса) = Неопределено Тогда
				
				ТекстСообщения = НСтр("ru = 'Ресурс """"%1%"""" не используется в источнике данных """"%2%""""!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяСтрока.ИмяРесурса, ТекущаяСтрока.ИсточникДанных);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				ТекущаяСтрока.ИмяРесурса = "";
				
			КонецЕсли;
			
		КонецЕсли;                     
		
		СписокПолей = СформироватьСписокПолей(ТекущаяСтрока.ИсточникДанных);
		
		Если ПустаяСтрока(ТекущаяСтрока.ИмяПоляТочки) Тогда
			
			// Если поле одно - можно сразу подставить
			Если СписокПолей.Количество() = 1 Тогда
				
			  ТекущаяСтрока.ИмяПоляТочки = СписокПолей[0].Значение;
				
			КонецЕсли;	
			
		Иначе
			
			// Проверка допустимости использования поля точки.
			Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) 
				 И СписокПолей.НайтиПоЗначению(ТекущаяСтрока.ИмяПоляТочки) = Неопределено Тогда
				
				ТекстСообщения = НСтр("ru = 'Поле """"%1%"""" не используется в источнике данных """"%2%""""!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяСтрока.ИмяПоляТочки, ТекущаяСтрока.ИсточникДанных);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				ТекущаяСтрока.ИмяПоляТочки = "";
				
			КонецЕсли;
			
		КонецЕсли;	
		
		Если НЕ ПустаяСтрока(ТекущаяСтрока.ИмяПоляСерии) Тогда
				
			// Проверка допустимости использования ресурсов.
			Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) 
				И СписокПолей.НайтиПоЗначению(ТекущаяСтрока.ИмяПоляСерии) = Неопределено Тогда
				
				ТекстСообщения = НСтр("ru = 'Поле """"%1%"""" не используется в источнике данных """"%2%""""!'");
				ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ТекущаяСтрока.ИмяПоляСерии, ТекущаяСтрока.ИсточникДанных);
				бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
				ТекущаяСтрока.ИмяПоляСерии = "";
				
			КонецЕсли;
			
		КонецЕсли;
		
		// Текстовый маркер используется в условном оформлении.
		ТекущаяСтрока.ТипИсточникаДанных = ?(ТипЗнч(ТекущаяСтрока.ИсточникДанных) = Тип("СправочникСсылка.бит_СпособыКомпоновкиИсточниковДанных"),"СК","ИД");
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.СерииДиаграмм.ТекущиеДанные;
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,ТекущиеДанные
	                                                   ,"ИсточникДанных"
													   ,фКэшЗначений.СписокТиповИсточникДанных
													   ,СтандартнаяОбработка);
													   
	
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммИсточникДанныхОчистка(Элемент, СтандартнаяОбработка)
		
	Элемент.ВыбиратьТип = Истина;

КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммИмяПоляСерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.СерииДиаграмм.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) Тогда
		
		СписокВыбора = СформироватьСписокПолей(ТекущаяСтрока.ИсточникДанных);
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммИмяПоляТочкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.СерииДиаграмм.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) Тогда
		
		СписокВыбора = СформироватьСписокПолей(ТекущаяСтрока.ИсточникДанных);
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммИмяРесурсаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущаяСтрока = Элементы.СерииДиаграмм.ТекущиеДанные;
	
	Если ЗначениеЗаполнено(ТекущаяСтрока.ИсточникДанных) Тогда
		
		СписокВыбора = СформироватьСписокРесурсов(ТекущаяСтрока.ИсточникДанных);
		ДанныеВыбора = Новый СписокЗначений;
		ДанныеВыбора.ЗагрузитьЗначения(СписокВыбора.ВыгрузитьЗначения());
		
	КонецЕсли;	
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммФорматПоляСерииНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ОткрытьКонструкторФормата("СерииДиаграмм", "ФорматПоляСерии");
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммФорматПоляТочкиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ОткрытьКонструкторФормата("СерииДиаграмм", "ФорматПоляТочки");
	
КонецПроцедуры

&НаКлиенте
Процедура СерииДиаграммФорматНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	ОткрытьКонструкторФормата("СерииДиаграмм", "Формат");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыТаблицыДиаграмм

&НаКлиенте
Процедура ТаблицыПрезентацииИсточникДанныхПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ТаблицыПрезентации.ТекущиеДанные;
	// Текстовый маркер используется в условном оформлении.
	ТекущаяСтрока.ТипИсточникаДанных = ?(ТипЗнч(ТекущаяСтрока.ИсточникДанных) = Тип("СправочникСсылка.бит_СпособыКомпоновкиИсточниковДанных"),"СК","ИД");
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыПрезентацииИсточникДанныхНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ТаблицыПрезентации.ТекущиеДанные;
	бит_РаботаСДиалогамиКлиент.НачалоВыбораСоставного(ЭтаФорма
	                                                   ,Элемент
	                                                   ,ТекущиеДанные
	                                                   ,"ИсточникДанных"
													   ,фКэшЗначений.СписокТиповИсточникДанных
													   ,СтандартнаяОбработка);
													   
	
	
КонецПроцедуры

&НаКлиенте
Процедура ТаблицыПрезентацииИсточникДанныхОчистка(Элемент, СтандартнаяОбработка)
		
	Элемент.ВыбиратьТип = Истина;

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗагрузитьМакет(Команда)
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Открытие);
	Диалог.Фильтр =  НСтр("ru = 'Файлы Power point(*.pptx)|*.pptx'");
	Оповещение = Новый ОписаниеОповещения("ДиалогЗагрузитьЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	
КонецПроцедуры

// Процедура обработчик оповещения "ДиалогЗагрузитьЗавершение".
// 
// Параметры:
// ВыбранныеФайлы - Массив
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ДиалогЗагрузитьЗавершение(ВыбранныеФайлы, ДополнительныеДанные) Экспорт

	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		Файл = Новый Файл(ПолноеИмяФайла);
		Если ПустаяСтрока(Объект.Наименование) Тогда
			
			Объект.Наименование = Файл.ИмяБезРасширения;
			
		КонецЕсли; 
		
		ДанныеМакета = Новый ДвоичныеДанные(ПолноеИмяФайла);
		фАдресХранилищаМакета = ПоместитьВоВременноеХранилище(ДанныеМакета, УникальныйИдентификатор);
		Модифицированность = Истина;
		фЗагружен = Истина;
		УправлениеЭлементамиФормы();
	
	КонецЕсли; 
	
КонецПроцедуры	// ДиалогЗагрузитьЗавершение

&НаКлиенте
Процедура КомандаСохранитьМакет(Команда)
	
	Если НЕ фЗагружен Тогда
		
		ТекстСообщения =  НСтр("ru = 'Макет еще не загружен. Сохранение не возможно.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	Если Модифицированность Тогда
	
		ТекстСообщения =  НСтр("ru = 'Для продолжения необходимо записать элемент.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	Диалог = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.Сохранение);
	Диалог.Фильтр =  НСтр("ru = 'Файлы Power point(*.pptx)|*.pptx'");
	Диалог.ПолноеИмяФайла = Объект.Наименование+".pptx";
	Оповещение = Новый ОписаниеОповещения("ДиалогСохранитьЗавершение", ЭтотОбъект);
	Диалог.Показать(Оповещение);
	 
	
КонецПроцедуры

// Процедура обработчик оповещения "ДиалогСохранитьЗавершение".
// 
// Параметры:
// ВыбранныеФайлы - Массив
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ДиалогСохранитьЗавершение(ВыбранныеФайлы, ДополнительныеДанные) Экспорт

	Если ТипЗнч(ВыбранныеФайлы) = Тип("Массив") И ВыбранныеФайлы.Количество() > 0 Тогда
		
		ПолноеИмяФайла = ВыбранныеФайлы[0];
		ИзвлечьМакет();
		Если ЭтоАдресВременногоХранилища(фАдресХранилищаМакетаСохранение) Тогда
			
			 ДанныеМакета = ПолучитьИзВременногоХранилища(фАдресХранилищаМакетаСохранение);
			 ДанныеМакета.Записать(ПолноеИмяФайла);
			 
			 ТекстСообщения = НСтр("ru = 'Сохранен файл %1%.'");
			 ТекстСообщения = бит_ОбщегоНазначенияКлиентСервер.ПодставитьПараметрыСтроки(ТекстСообщения, ПолноеИмяФайла);
			 Состояние(ТекстСообщения);
			 
			 фАдресХранилищаМакетаСохранение = "";
			 
		КонецЕсли; 
	
	КонецЕсли; 
	
КонецПроцедуры	// ДиалогСохранитьЗавершение

&НаКлиенте
Процедура КомандаОткрытьМакет(Команда)
	
	Если НЕ фЗагружен Тогда
		
		ТекстСообщения =  НСтр("ru = 'Макет еще не загружен.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	Если Модифицированность Тогда
	
		ТекстСообщения =  НСтр("ru = 'Для продолжения необходимо записать элемент.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	ИзвлечьМакет();
	Если ЭтоАдресВременногоХранилища(фАдресХранилищаМакетаСохранение) Тогда
		
		ИмяФайлаВрем = КаталогВременныхФайлов()+Объект.Наименование+".pptx";
		
		ДанныеМакета = ПолучитьИзВременногоХранилища(фАдресХранилищаМакетаСохранение);
		ДанныеМакета.Записать(ИмяФайлаВрем);
		
		фАдресХранилищаМакетаСохранение = "";
		
		Отказ = Ложь;
		
		PowerPointApp = бит_ПауэрПойтнКлиентСервер.InitPowerPoint(Ложь, Истина, Отказ);
		
		Presentation = бит_ПауэрПойтнКлиентСервер.OpenPowerPointFile(PowerPointApp, ИмяФайлаВрем, Отказ);		
		
	КонецЕсли; 
		
КонецПроцедуры

&НаКлиенте
Процедура КомандаАнализироватьМакет(Команда)
	
	Если НЕ фЗагружен Тогда
		
		ТекстСообщения =  НСтр("ru = 'Макет еще не загружен.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	Если Модифицированность Тогда
	
		ТекстСообщения =  НСтр("ru = 'Для продолжения необходимо записать элемент.'");
		бит_ОбщегоНазначенияКлиентСервер.ВывестиСообщение(ТекстСообщения);
		Возврат;
	
	КонецЕсли; 
	
	флЕстьДанные = ?(Объект.ТаблицыПрезентации.Количество()>0 
	                  ИЛИ Объект.СерииДиаграмм.Количество()>0 
					  ИЛИ Объект.ПараметрыПрезентации.Количество()>0, Истина, Ложь);
	
					  
    Если флЕстьДанные Тогда
	
		ТекстВопроса =  НСтр("ru = 'Данные будут очищены. Продолжить?'");
		Оповещение = Новый ОписаниеОповещения("ВопросАнализЗавершение", ЭтотОбъект);
		ПоказатьВопрос(Оповещение, ТекстВопроса,РежимДиалогаВопрос.ДаНет, 15, КодВозвратаДиалога.Нет);
		
	Иначе
		
		ВыполнитьАнализ();
	
	КонецЕсли; 					  
	
КонецПроцедуры

// Процедура обработчик оповещения "ВопросАнализЗавершение".
// 
// Параметры:
// Ответ - КодВозвратаДиалога
// ДополнительныеДанные - Структура.
// 
&НаКлиенте 
Процедура ВопросАнализЗавершение(Ответ, ДополнительныеДанные) Экспорт

	Если Ответ = КодВозвратаДиалога.Да Тогда
	
		 ВыполнитьАнализ();
	
	КонецЕсли; 
	
КонецПроцедуры	// ВопросАнализЗавершение

// Выполняет анализ структуры презентации.
// 
&НаКлиенте
Процедура ВыполнитьАнализ()
	
	Объект.ТаблицыПрезентации.Очистить();
	Объект.СерииДиаграмм.Очистить();
	Объект.ПараметрыПрезентации.Очистить();
	Объект.ДиаграммыПрезентации.Очистить();
	
	Состояние( НСтр("ru = 'Анализ структуры файла презентации...'"));
	
	ИзвлечьМакет();
	Если ЭтоАдресВременногоХранилища(фАдресХранилищаМакетаСохранение) Тогда
		
		// Сохранение файла во временный каталог
		ИмяФайлаВрем = КаталогВременныхФайлов()+Строка(Новый УникальныйИдентификатор)+".pptx";
		
		ДанныеМакета = ПолучитьИзВременногоХранилища(фАдресХранилищаМакетаСохранение);
		ДанныеМакета.Записать(ИмяФайлаВрем);
		
		// Анализ структуры файла
		Отказ = Ложь;
		
		PowerPointApp = бит_ПауэрПойтнКлиентСервер.InitPowerPoint(Ложь, Истина, Отказ);
		
		Presentation = бит_ПауэрПойтнКлиентСервер.OpenPowerPointFile(PowerPointApp, ИмяФайлаВрем, Отказ);
		
		Если Отказ Тогда
			Возврат;
		КонецЕсли;
		
		Для Каждого Slide Из Presentation.Slides Цикл
			
			// Сообщить(Slide.Name+" "+Slide.SlideID);
			
			Для Каждого Shape Из Slide.Shapes Цикл
				
				Если Shape.HasTextFrame Тогда
					
					// Сообщить(Shape.TextFrame.TextRange.Text);
					Текст = Shape.TextFrame.TextRange.Text;
					
					Если Найти(Текст,"{%")>0 Тогда
						
						МассивВрем = бит_СтрокиКлиентСервер.РазобратьСтрокуСРазделителями(Текст,"%}");
						Для каждого СтрВрем Из МассивВрем Цикл
							
							ПозНач = Найти(СтрВрем,"{%");
							Если ПозНач > 0 Тогда
								
								ИмяПараметра = Сред(СтрВрем, ПозНач+2);
								
								
								СтрОтбор = Новый Структура("Имя", ИмяПараметра);
								НайденныеСтроки = Объект.ПараметрыПрезентации.НайтиСтроки(СтрОтбор);
								Если НайденныеСтроки.Количество() = 0 Тогда
									
									// Если такого параметра нет, то добавляем его без учета слайда.
									НоваяСтрока = Объект.ПараметрыПрезентации.Добавить();
									НоваяСтрока.Имя = ИмяПараметра;
									
								Иначе	
									
									// Если такой параметр уже есть, то добавляем параметр для конкретного слайда.
									СтрОтбор = Новый Структура("КонтейнерИД, Имя", ИмяПараметра);
									НайденныеСтроки = Объект.ПараметрыПрезентации.НайтиСтроки(СтрОтбор);
									
									Если НайденныеСтроки.Количество() = 0 Тогда
										
										НоваяСтрока = Объект.ПараметрыПрезентации.Добавить();
										НоваяСтрока.КонтейнерПредставление = Slide.Name;
										НоваяСтрока.КонтейнерИД = Slide.SlideID;
										НоваяСтрока.Имя = ИмяПараметра;
										
									Иначе	 
										
										// В рамках одного слайда параметры не дублируем.
										
									КонецЕсли; 
									
									
								КонецЕсли; 
								
								// Сообщить(ИмяПараметра);
								
							КонецЕсли; 
							
						КонецЦикла; 
						
					КонецЕсли; 
					
				ИначеЕсли Shape.HasChart Тогда
					
					НоваяСтрока = Объект.ДиаграммыПрезентации.Добавить();
					НоваяСтрока.КонтейнерПредставление = Slide.Name;
					НоваяСтрока.КонтейнерИД            = Slide.SlideID;
					НоваяСтрока.Имя                    = Shape.Chart.Name;
					НоваяСтрока.Заголовок              = Shape.Chart.Title;
					НоваяСтрока.ИД                     = Новый УникальныйИдентификатор;
					
				ИначеЕсли Shape.HasTable Тогда
					
					НоваяСтрока = Объект.ТаблицыПрезентации.Добавить();
					НоваяСтрока.КонтейнерПредставление = Slide.Name;
					НоваяСтрока.КонтейнерИД            = Slide.SlideID;
					НоваяСтрока.Имя = Shape.Table.Title;
					
					
				КонецЕсли; 
				
			КонецЦикла;
			
		КонецЦикла;	
		
		Presentation.Close();
		бит_ПауэрПойтнКлиентСервер.QuitPowerPoint(PowerPointApp);
		
		// Удаление временного файла
		Файл = Новый Файл(ИмяФайлаВрем);
		ДопПараметры = Новый Структура;
		ДопПараметры.Вставить("ПолноеИмя", Файл.ПолноеИмя);
		Оповещение = Новый ОписаниеОповещения("ВыполнитьАнализЗавершение", ЭтотОбъект, ДопПараметры); 
		Файл.НачатьПроверкуСуществования(Оповещение)
		
	КонецЕсли; 
	
КонецПроцедуры // ВыполнитьАнализ()

// Обработчик завершения метода "Выполнить анализ".
//  См. Синтакс-помощник: НачатьПроверкуСуществования().
//
&НаКлиенте 
Процедура ВыполнитьАнализЗавершение(Существует, ДополнительныеПараметры) Экспорт
	
	Если Существует = Истина Тогда
		Оповещение = Новый ОписаниеОповещения("УдалитьЗавершение", ЭтотОбъект);
		НачатьУдалениеФайлов(Оповещение, ДополнительныеПараметры.ПолноеИмя)
	КонецЕсли; 
	
КонецПроцедуры

// Обработчик завершения метода "Выполнить Анализ Завершение".
//  См. Синтакс-помощник: НачатьУдалениеФайлов().
//
&НаКлиенте 
Процедура УдалитьЗавершение(ДополнительныеПараметры) Экспорт
	
	ТекстСообщения = НСтр("ru = 'Удаление успешно завершено'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры
 

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

// Процедура управляет видимостью/доступностью элементов формы. 
// 
&НаСервере
Процедура УправлениеЭлементамиФормы()

	Если фЗагружен Тогда
		ТекстЗаголовка = НСтр("ru = 'Макет загружен'");
		Элементы.ДекорацияИнфоМакет.Заголовок = ТекстЗаголовка;
		Элементы.ДекорацияИнфоМакет.ЦветТекста = WebЦвета.Синий;		
	Иначе	
		Элементы.ДекорацияИнфоМакет.Заголовок = НСтр("ru = 'Макет не загружен!'");
		Элементы.ДекорацияИнфоМакет.ЦветТекста = WebЦвета.Красный;
	КонецЕсли; 

КонецПроцедуры // УправлениеЭлементамиФормы()

// Процедура извлекает макет презентации из хранилища значения.
// 
&НаСервере
Процедура ИзвлечьМакет()

	СпрОб = ДанныеФормыВЗначение(Объект, Тип("СправочникОбъект.бит_мпд_НастройкиПрезентацийОтчетности"));
	ДанныеМакета = СпрОб.ИзвлечьМакет();
	Если ТипЗнч(ДанныеМакета) = Тип("ДвоичныеДанные") Тогда
		
		фАдресХранилищаМакетаСохранение = ПоместитьВоВременноеХранилище(ДанныеМакета, УникальныйИдентификатор);
		
	Иначе
		
		фАдресХранилищаМакетаСохранение = "";
		
	КонецЕсли; 

КонецПроцедуры // ИзвлечьМакет()

// Функция формирует список ресурсов ИсточникаДанных либо СпособаКомпоновкиИсточниковДанных.
// 
&НаСервере
Функция СформироватьСписокРесурсов(ТекИсточникДанных)
	
	Список = Новый СписокЗначений;
	
	Если ТипЗнч(ТекИсточникДанных) = Тип("СправочникСсылка.бит_СпособыКомпоновкиИсточниковДанных") Тогда
		
		Список = бит_МеханизмПолученияДанных.ПолучитьСписокПолейДляСпособаКомпоновки(ТекИсточникДанных,"Ресурс","СписокЗначений");
		
	ИначеЕсли ТипЗнч(ТекИсточникДанных) = Тип("СправочникСсылка.бит_ИсточникиДанных") Тогда
		
		Список = Справочники.бит_ИсточникиДанных.ПолучитьСписокПолейИсточника(ТекИсточникДанных,"Ресурс");
		
	КонецЕсли;
	
	Возврат Список;
	
КонецФункции

// Функция формирует список полей ИсточникаДанных либо СпособаКомпоновкиИсточниковДанных.
// 
&НаСервере
Функция СформироватьСписокПолей(ТекИсточникДанных)
	
	Список = Новый СписокЗначений;
	
	Если ТипЗнч(ТекИсточникДанных) = Тип("СправочникСсылка.бит_СпособыКомпоновкиИсточниковДанных") Тогда
		
		Список = бит_МеханизмПолученияДанных.ПолучитьСписокПолейДляСпособаКомпоновки(ТекИсточникДанных,"Поле","СписокЗначений");
		
	ИначеЕсли ТипЗнч(ТекИсточникДанных) = Тип("СправочникСсылка.бит_ИсточникиДанных") Тогда
		
		Список = Справочники.бит_ИсточникиДанных.ПолучитьСписокПолейИсточника(ТекИсточникДанных,"Поле");
		
	КонецЕсли;
	
	Возврат Список;
	
КонецФункции

// Процедура открывает конструктор формата. 
// 
// Параметры:
//  ИмяТаблицы - Строка.
//  ИмяПоля - Строка
//  ТекущийФормат - Строка
// 
&НаКлиенте
Процедура ОткрытьКонструкторФормата(ИмяТаблицы, ИмяПоля)

	ТекущаяСтрока = Элементы[ИмяТаблицы].ТекущиеДанные;	
	
	КонструктовФормата = Новый КонструкторФорматнойСтроки(ТекущаяСтрока[ИмяПоля]);
	
	МассивТипов = Новый Массив;
	МассивТипов.Добавить("Число");
	МассивТипов.Добавить("Дата");
	МассивТипов.Добавить("Строка");
	МассивТипов.Добавить("Булево");	
	КонструктовФормата.ДоступныеТипы = Новый ОписаниеТипов(МассивТипов);

	ДопПараметры = Новый Структура;
	ДопПараметры.Вставить("ИмяТаблицы", ИмяТаблицы);
	ДопПараметры.Вставить("ИмяПоля", ИмяПоля);
	
	Оповещение = Новый ОписаниеОповещения("КонструкторФорматаЗавершение", ЭтотОбъект, ДопПараметры);
	
	КонструктовФормата.Показать(Оповещение);
	
КонецПроцедуры // ОткрытьКонструкторФормата()

// Процедура обрабатывает завершение выбора формата. 
// 
// 
&НаКлиенте 
Процедура КонструкторФорматаЗавершение(РезДанные, ДополнительныеДанные) Экспорт
	
	Если НЕ РезДанные = Неопределено Тогда
		
		ТекущаяСтрока = Элементы[ДополнительныеДанные.ИмяТаблицы].ТекущиеДанные;
		ТекущаяСтрока[ДополнительныеДанные.ИмяПоля] = РезДанные;
		Модифицированность = Истина;
		
	КонецЕсли; 
	
КонецПроцедуры	// КонструкторФорматаЗавершение

#КонецОбласти

