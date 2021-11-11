﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	бит_РаботаСДиалогамиСервер.ФормаЗаписиРегистраПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект);
		
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ПодготовитьФормуНаСервере();
	
	// Настроим отображение полей доп. аналитик в форме.
	бит_МеханизмДопИзмерений.ОтобразитьДополнительныеИзмеренияНаФорме_Управляемая(ЭтаФорма
																				 ,ИзмеренияДоп
																				 ,Новый Соответствие(НастройкиИзмерений));
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменениеСтатьиОборотов();	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура СтатьяОборотовПриИзменении(Элемент)
	ИзменениеСтатьиОборотов();	
КонецПроцедуры

&НаКлиенте
Процедура ОбъектНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
		
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ВидыОбъектов"           , СписокВидовОбъектов);
	ПараметрыФормы.Вставить("ТекущийОбъектСистемы"   , Запись.Объект);
	ПараметрыФормы.Вставить("ДоступныеОбъектыСистемы", СписокОбъектовСистемы);
	ОткрытьФорму("ОбщаяФорма.бит_ФормаВыбораОбъектовСистемыУправляемая", ПараметрыФормы, Элемент);
	
КонецПроцедуры

// Процедура - обработчик события "НачалоВыбора" полей ввода "Аналитика_i" (i от 1 до 7).
// 
&НаКлиенте
Процедура Аналитика_НачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
	                                                      	   ,Элемент
															   ,Запись
															   ,Элемент.Имя
															   ,СтандартнаяОбработка
															   ,Новый Соответствие(НастройкиИзмерений));
	
 КонецПроцедуры
 
// Процедура - обработчик события "АвтоПодбор" полей ввода "Аналитика_i" (i от 1 до 7).
// 
&НаКлиенте
Процедура Аналитика_АвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
    
    бит_МеханизмДопИзмеренийКлиент.ВыбратьТипСоставнойАналитики(ЭтаФорма
	                                                      	   ,Элемент
															   ,Запись
															   ,Элемент.Имя
															   ,СтандартнаяОбработка
															   ,Новый Соответствие(НастройкиИзмерений));
                                                               
КонецПроцедуры // Аналитика_АвтоПодбор()

// Процедура - обработчик события "Очистка" полей ввода "Аналитика_i" (i от 1 до 7).
// 
&НаКлиенте
Процедура Аналитика_Очистка(Элемент, СтандартнаяОбработка)
	
	бит_МеханизмДопИзмеренийКлиент.ОбработкаОчисткиДополнительногоИзмерения(Элемент
																			,Запись
	                                                                       	,Элемент.Имя
																		   	,СтандартнаяОбработка
																		   	,Новый Соответствие(НастройкиИзмерений));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВставитьШаблон(Команда)
	
	Оповещение = Новый ОписаниеОповещения("ОчисткаШаблона", ЭтотОбъект); 
	Если ЗначениеЗаполнено(Запись.МаскаНазначенияПлатежа) Тогда
	
		ТекстВопроса = НСтр("ru = 'Очистить маску назначения платежа?'");
		ПоказатьВопрос(Оповещение,ТекстВопроса,РежимДиалогаВопрос.ДаНетОтмена,30);
		
	Иначе	
		ВыполнитьОбработкуОповещения(Оповещение, КодВозвратаДиалога.Нет);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура окончание процедуры "ВставитьШаблон". 
//
// Параметры:
// Ответ - КодВозвратаДиалога
// ДополнительныеДанные - Структура.
//
&НаКлиенте 
Процедура ОчисткаШаблона(Ответ, ДополнительныеДанные) Экспорт
	
	Оповещение = Новый ОписаниеОповещения("ВставитьШаблонОкончание", ЭтотОбъект); 
	ПараметрыФормы = Новый Структура("Шаблон", "");
	
	Если Ответ = КодВозвратаДиалога.Да Тогда
		
		Запись.МаскаНазначенияПлатежа = "";
		ОткрытьФорму("РегистрСведений.бит_НастройкиЗаполненияАналитикПоНазначениюПлатежа.Форма.ФормаШаблона",ПараметрыФормы,,,,,Оповещение);
		
	ИначеЕсли Ответ = КодВозвратаДиалога.Нет Тогда	
		
		ПараметрыФормы.Шаблон = Запись.МаскаНазначенияПлатежа;
		ОткрытьФорму("РегистрСведений.бит_НастройкиЗаполненияАналитикПоНазначениюПлатежа.Форма.ФормаШаблона",ПараметрыФормы,,,,,Оповещение);
		
	КонецЕсли; 
                
КонецПроцедуры

// Процедура - Вставить шаблон окончание.
//
// Параметры:
//  РезультатВыбора			 - Структура - результат.
//  ДополнительныеПараметры	 - Структура - параметры.
//
&НаКлиенте 
Процедура ВставитьШаблонОкончание(РезультатВыбора, ДополнительныеПараметры) Экспорт
	
	Если РезультатВыбора <> Неопределено Тогда
		Запись.МаскаНазначенияПлатежа = РезультатВыбора;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПодготовитьФормуНаСервере()
	
	ИзмеренияДоп = бит_Бюджетирование.ПолучитьИзмеренияБюджетирования("Дополнительные","Синоним");
	НастройкиИзмерений = Новый ФиксированноеСоответствие(бит_ОбщиеПеременныеСервер.ЗначениеПеременной("бит_НастройкиДополнительныхИзмерений"));
	
	СписокВидовОбъектов = Новый СписокЗначений;
	СписокВидовОбъектов.Добавить(Перечисления.бит_ВидыОбъектовСистемы.Документ);
	
	СписокОбъектовСистемы = Новый СписокЗначений;
	СписокОбъектовСистемы.Добавить(бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(Метаданные.Документы.СписаниеСРасчетногоСчета));			
	СписокОбъектовСистемы.Добавить(бит_ПраваДоступа.ПолучитьОбъектДоступаПоМетаданным(Метаданные.Документы.ПоступлениеНаРасчетныйСчет));			
	
КонецПроцедуры

&НаКлиенте
Процедура ИзменениеСтатьиОборотов()

	Если ЗначениеЗаполнено(Запись.СтатьяОборотов) Тогда
		
		ИзменениеСтатьиОборотовСервер(Запись.СтатьяОборотов);
		
	КонецЕсли; 

КонецПроцедуры

&НаСервере
Процедура ИзменениеСтатьиОборотовСервер(Статья)

	НастройкиСтатьи = Справочники.бит_СтатьиОборотов.ПолучитьНастройки(Запись.СтатьяОборотов);
	бит_Бюджетирование.УстановитьИспользованиеАналитики(Запись, НастройкиСтатьи, ИзмеренияДоп);
	НастроитьВидимостьАналитикБюджетирования();
	
КонецПроцедуры // ИзменениеСтатьиОборотов()

&НаСервере
Процедура НастроитьВидимостьАналитикБюджетирования()
	
	МассивСтатей = Новый Массив;
	МассивСтатей.Добавить(Запись.СтатьяОборотов);
	Префикс = "";
	
	МассивИсключаемыхИзмерений = Новый Массив;
	МассивИсключаемыхИзмерений.Добавить("Организация");
	МассивИсключаемыхИзмерений.Добавить("ЦФО");
	МассивИсключаемыхИзмерений.Добавить("СтатьяОборотов");
	МассивИсключаемыхИзмерений.Добавить("Проект");
	МассивИсключаемыхИзмерений.Добавить("Контрагент");
	МассивИсключаемыхИзмерений.Добавить("ДоговорКонтрагента");
	МассивИсключаемыхИзмерений.Добавить("БанковскийСчет");
	
	НастройкаВидимости = бит_Бюджетирование.ПолучитьНастройкуВидимостиКолонок(МассивСтатей, Неопределено);
	
	Для Каждого ТекИзмерение Из МассивИсключаемыхИзмерений Цикл
		
		Если НЕ НастройкаВидимости.Свойство(ТекИзмерение) Тогда
			Продолжить;
		КонецЕсли;
		
		НастройкаВидимости.Удалить(ТекИзмерение);
		
	КонецЦикла;
	
	бит_РаботаСДиалогамиСервер.УправлениеВидимостьюКолонокТабличногоПоля(Элементы, НастройкаВидимости, Префикс);
	
КонецПроцедуры

#КонецОбласти
