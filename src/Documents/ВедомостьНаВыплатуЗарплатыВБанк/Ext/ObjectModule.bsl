﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	Если Документы.ВедомостьНаВыплатуЗарплатыВБанк.ЭтоДанныеЗаполненияНезачисленнымиСтроками(ДанныеЗаполнения) Тогда
		ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения)
	Иначе	
		ВедомостьНаВыплатуЗарплаты.ОбработкаЗаполнения(ЭтотОбъект, ДанныеЗаполнения, СтандартнаяОбработка);
	КонецЕсли
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НЕ ЗначениеЗаполнено(ЗарплатныйПроект) Тогда
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Зарплата.НомерЛицевогоСчета");
		ОбщегоНазначенияКлиентСервер.УдалитьЗначениеИзМассива(ПроверяемыеРеквизиты, "Состав.НомерЛицевогоСчета");
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектамПереопределяемый.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроверкиЗаполнения(ЭтотОбъект, Отказ, ПроверяемыеРеквизиты);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ВедомостьНаВыплатуЗарплаты.ПередЗаписью(ЭтотОбъект, Отказ, РежимЗаписи); 
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВедомостьНаВыплатуЗарплатыВБанкПередЗаписью(ЭтотОбъект);
	
КонецПроцедуры

Процедура ПриЗаписи(Отказ)
	
	Если ЗарплатаКадры.ОтключитьБизнесЛогикуПриЗаписи(ЭтотОбъект) Тогда
		Возврат;
	КонецЕсли;
	
	ОбменСБанкамиПоЗарплатнымПроектам.ВедомостьНаВыплатуЗарплатыВБанкПриЗаписи(ЭтотОбъект, Отказ);
	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	ВедомостьНаВыплатуЗарплаты.ОбработкаПроведения(ЭтотОбъект, Отказ);
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	НомерРеестра = 0;
	
	Руководитель          = "";
	ДолжностьРуководителя = "";
	ГлавныйБухгалтер      = "";
	Бухгалтер             = "";
	
	НДФЛ.Очистить();
	Для Каждого СтрокаТаблицы ИЗ Зарплата Цикл
		СтрокаТаблицы.ДокументОснование             = "";
		СтрокаТаблицы.КВыплате                      = 0;
		СтрокаТаблицы.КомпенсацияЗаЗадержкуЗарплаты = 0;
		СтрокаТаблицы.ПериодВзаиморасчетов          = ПериодРегистрации
	КонецЦикла;
	
	СвернутьТаблицу = Ложь;
	Для Каждого СтрокаСостава ИЗ Состав Цикл
		МассивСтрок = Зарплата.НайтиСтроки(Новый Структура("ИдентификаторСтроки", СтрокаСостава.ИдентификаторСтроки));
		Если МассивСтрок.Количество() > 1 Тогда
			СвернутьТаблицу = Истина;
			ЗаполнениеПодразделение        = Неопределено;
			ЗаполнениеСтатьяФинансирования = Неопределено;
			ЗаполнениеСтатьяРасходов       = Неопределено;
			Для Каждого СтрокаМассива ИЗ МассивСтрок Цикл
				Если ЗаполнениеПодразделение = Неопределено Тогда
					ЗаполнениеПодразделение = СтрокаМассива.Подразделение;
				КонецЕсли;
				Если ЗаполнениеСтатьяФинансирования = Неопределено Тогда
					ЗаполнениеСтатьяФинансирования = СтрокаМассива.СтатьяФинансирования;
				КонецЕсли;
				Если ЗаполнениеСтатьяРасходов = Неопределено Тогда
					ЗаполнениеСтатьяРасходов = СтрокаМассива.СтатьяРасходов;
				КонецЕсли;
			КонецЦикла;
			Для Каждого СтрокаМассива ИЗ МассивСтрок Цикл
				СтрокаМассива.Подразделение        = ЗаполнениеПодразделение;
				СтрокаМассива.СтатьяФинансирования = ЗаполнениеСтатьяФинансирования;
				СтрокаМассива.СтатьяРасходов       = ЗаполнениеСтатьяРасходов;
			КонецЦикла;
		КонецЕсли;
	КонецЦикла;
	
	Если СвернутьТаблицу Тогда
		ЗарплатаВременная = Зарплата.Выгрузить();
		ЗарплатаВременная.Свернуть("ИдентификаторСтроки, Сотрудник, ФизическоеЛицо, Подразделение, НомерЛицевогоСчета,
										|ПериодВзаиморасчетов, СтатьяФинансирования, СтатьяРасходов, ДокументОснование",
									"КВыплате, КомпенсацияЗаЗадержкуЗарплаты");
		Зарплата.Загрузить(ЗарплатаВременная);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

// Возвращает признак изменения данных, влияющих на формирование электронного документа.
// 
Функция ИзменилисьКлючевыеРеквизитыЭлектронногоДокумента() Экспорт
	
	ИзменилисьКлючевыеРеквизиты = 
		ЭлектронноеВзаимодействиеБЗК.ИзменилисьРеквизитыОбъекта(ЭтотОбъект, "Дата, Номер, Организация, ЗарплатныйПроект, НомерРеестра, ПометкаУдаления")	
		Или ЭлектронноеВзаимодействиеБЗК.ИзмениласьТабличнаяЧастьОбъекта(ЭтотОбъект, "Зарплата", "Сотрудник, КВыплате, НомерЛицевогоСчета");
		
	Возврат ИзменилисьКлючевыеРеквизиты;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область СценарииЗаполненияДокумента

Функция МожноЗаполнитьЗарплату() Экспорт
	Возврат ВедомостьНаВыплатуЗарплаты.МожноЗаполнитьЗарплату(ЭтотОбъект);
КонецФункции

#КонецОбласти

#Область МестоВыплаты

Функция МестоВыплаты() Экспорт
	МестоВыплаты = ВедомостьНаВыплатуЗарплаты.МестоВыплаты();
	МестоВыплаты.Вид      = Перечисления.ВидыМестВыплатыЗарплаты.ЗарплатныйПроект;
	МестоВыплаты.Значение = ЗарплатныйПроект;
	Возврат МестоВыплаты
КонецФункции

Процедура УстановитьМестоВыплаты(Значение) Экспорт
	ЗарплатныйПроект = Значение
КонецПроцедуры

#КонецОбласти

#Область ЗаполнениеДокумента

Процедура ОчиститьВыплаты() Экспорт
	ВедомостьНаВыплатуЗарплаты.ОчиститьВыплаты(ЭтотОбъект);
КонецПроцедуры	

Процедура ЗагрузитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатНомерамиЛицевыхСчетов(Зарплата);
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо, НомерЛицевогоСчета");
КонецПроцедуры

Процедура ДобавитьВыплаты(Зарплата, НДФЛ) Экспорт
	ДополнитьТаблицуЗарплатНомерамиЛицевыхСчетов(Зарплата);
	ВедомостьНаВыплатуЗарплаты.ДобавитьВыплаты(ЭтотОбъект, Зарплата, НДФЛ, "ФизическоеЛицо, НомерЛицевогоСчета")
КонецПроцедуры

Процедура УстановитьНДФЛ(НДФЛ, Знач ФизическиеЛица = Неопределено) Экспорт
	ВедомостьНаВыплатуЗарплаты.УстановитьНДФЛ(ЭтотОбъект, НДФЛ, ФизическиеЛица)
КонецПроцедуры

// Заполняет документ на основании существующего,
// перенося в документ зарплату и налоги указанных физических лиц.
// 
// Параметры:
//	ДанныеЗаполнения - Структура - см. ВедомостьНаВыплатуЗарплатыВБанк.ДанныеЗаполненияНезачисленнымиСтроками().
//
Процедура ЗаполнитьНезачисленнымиСтроками(ДанныеЗаполнения)
	
	Реквизиты = Новый Массив;
	Для Каждого Реквизит Из ДанныеЗаполнения.Ведомость.Метаданные().Реквизиты Цикл
		Реквизиты.Добавить(Реквизит.Имя);
	КонецЦикла;
	
	Шапка = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ДанныеЗаполнения.Ведомость, Реквизиты);
	ЗаполнитьЗначенияСвойств(ЭтотОбъект, Шапка, , "НомерРеестра");
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Ссылка", ДанныеЗаполнения.Ведомость.Ссылка);
	Запрос.УстановитьПараметр("Физлица", ДанныеЗаполнения.Физлица);
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ВедомостьЗарплата.Сотрудник КАК Сотрудник,
	|	ВедомостьЗарплата.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьЗарплата.Подразделение КАК Подразделение,
	|	ВедомостьЗарплата.ПериодВзаиморасчетов КАК ПериодВзаиморасчетов,
	|	ВедомостьЗарплата.СтатьяФинансирования КАК СтатьяФинансирования,
	|	ВедомостьЗарплата.СтатьяРасходов КАК СтатьяРасходов,
	|	ВедомостьЗарплата.ДокументОснование КАК ДокументОснование,
	|	ВедомостьЗарплата.КВыплате КАК КВыплате,
	|	ВедомостьЗарплата.КомпенсацияЗаЗадержкуЗарплаты КАК КомпенсацияЗаЗадержкуЗарплаты,
	|	ВедомостьЗарплата.НомерЛицевогоСчета КАК НомерЛицевогоСчета
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.Зарплата КАК ВедомостьЗарплата
	|ГДЕ
	|	ВедомостьЗарплата.Ссылка = &Ссылка
	|	И ВедомостьЗарплата.ФизическоеЛицо В(&Физлица)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ВедомостьНДФЛ.ФизическоеЛицо КАК ФизическоеЛицо,
	|	ВедомостьНДФЛ.СтавкаНалогообложенияРезидента КАК СтавкаНалогообложенияРезидента,
	|	ВедомостьНДФЛ.МесяцНалоговогоПериода КАК МесяцНалоговогоПериода,
	|	ВедомостьНДФЛ.КодДохода КАК КодДохода,
	|	ВедомостьНДФЛ.РегистрацияВНалоговомОргане КАК РегистрацияВНалоговомОргане,
	|	ВедомостьНДФЛ.Подразделение КАК Подразделение,
	|	ВедомостьНДФЛ.ВключатьВДекларациюПоНалогуНаПрибыль КАК ВключатьВДекларациюПоНалогуНаПрибыль,
	|	ВедомостьНДФЛ.ДокументОснование КАК ДокументОснование,
	|	ВедомостьНДФЛ.Сумма КАК Сумма,
	|	ВедомостьНДФЛ.КатегорияДохода КАК КатегорияДохода
	|ИЗ
	|	Документ.ВедомостьНаВыплатуЗарплатыВБанк.НДФЛ КАК ВедомостьНДФЛ
	|ГДЕ
	|	ВедомостьНДФЛ.Ссылка = &Ссылка
	|	И ВедомостьНДФЛ.ФизическоеЛицо В(&Физлица)";
	
	Незачисленное = Запрос.ВыполнитьПакет(); 
	НезачисленнаяЗарплата = Незачисленное[0].Выгрузить();
	НеудержанныйНДФЛ      = Незачисленное[1].Выгрузить();
	
	ВедомостьНаВыплатуЗарплаты.ЗагрузитьВыплаты(
		ЭтотОбъект, 
		НезачисленнаяЗарплата, 
		НеудержанныйНДФЛ, 
		"ФизическоеЛицо, НомерЛицевогоСчета");
	
КонецПроцедуры

Процедура ДополнитьТаблицуЗарплатНомерамиЛицевыхСчетов(ЗарплатаКВыплате)
	
	МетаданныеРеквизита = Метаданные().ТабличныеЧасти.Состав.Реквизиты.НомерЛицевогоСчета;
	ЗарплатаКВыплате.Колонки.Добавить(МетаданныеРеквизита.Имя, МетаданныеРеквизита.Тип);
	
	ЛицевыеСчетаСотрудников = ОбменСБанкамиПоЗарплатнымПроектам.ЛицевыеСчетаСотрудников(ЗарплатаКВыплате.ВыгрузитьКолонку("Сотрудник"), Истина, Организация, Дата, ЗарплатныйПроект);
	ЛицевыеСчетаСотрудников.Индексы.Добавить("Сотрудник"); 
	
	Для Каждого СтрокаЗарплаты Из ЗарплатаКВыплате Цикл
		СтрокаЛС = ЛицевыеСчетаСотрудников.Найти(СтрокаЗарплаты.Сотрудник, "Сотрудник");
		Если СтрокаЛС = Неопределено Тогда
			СтрокаЗарплаты.НомерЛицевогоСчета = "";
		Иначе
			СтрокаЗарплаты.НомерЛицевогоСчета = СтрокаЛС.НомерЛицевогоСчета
		КонецЕсли
	КонецЦикла
	
КонецПроцедуры	

#КонецОбласти

#КонецОбласти

#Иначе
ВызватьИсключение НСтр("ru = 'Недопустимый вызов объекта на клиенте.'");
#КонецЕсли