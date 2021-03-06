#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда
	
#Область ПрограммныйИнтерфейс

// Заполняет табличную часть элемента справочника параметрами реквизитов
// (элементами справочника "Виды реквизитов движений").
// 

// Процедура - Заполнить ТЧРеквизитами регистра
// Заполняет табличную часть элемента справочника параметрами реквизитов
// (элементами справочника "Виды реквизитов движений").
//
// Параметры:
//  РегистрСсылка	 - СправочникСсылка.бит_ВидыРеквизитовДвижений	 - группа.
//
Процедура ЗаполнитьТЧРеквизитамиРегистра(РегистрСсылка) Экспорт
	
	Если не ЗначениеЗаполнено(РегистрСсылка) Тогда
		Возврат;
	КонецЕсли;
	
	// Заполним табличную часть
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	бит_ВидыРеквизитовДвижений.Ссылка КАК Реквизит,
	               |	бит_ВидыРеквизитовДвижений.ПредставлениеЭлемента КАК СинонимРеквизита,
	               |	бит_ВидыРеквизитовДвижений.ТипыЗначений КАК ТипРеквизита,
	               |	ЗНАЧЕНИЕ(Перечисление.бит_ПоложенияКолонокТаблицы.НоваяКолонка) КАК ПоложениеКолонки,
	               |	20 КАК ШиринаКолонки,
	               |	ИСТИНА КАК Видимость
	               |ИЗ
	               |	Справочник.бит_ВидыРеквизитовДвижений КАК бит_ВидыРеквизитовДвижений
	               |ГДЕ
	               |	бит_ВидыРеквизитовДвижений.Родитель = &РегистрСсылка";
				   
	Запрос.УстановитьПараметр("РегистрСсылка", РегистрСсылка);
	Результат = Запрос.Выполнить().Выгрузить();
	Результат.Колонки.Добавить("НомерКолонки");
	жи = 0;
	
	Для Каждого Элемент Из Результат Цикл
		Элемент.НомерКолонки = жи;
		жи = жи + 1;
	КонецЦикла;
	
	ПараметрыКолонок.Загрузить(Результат);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)

	ПроверитьНаДубли(Отказ);
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияНачалоСобытия(Отказ, ЭтотОбъект.ДополнительныеСвойства);
	
КонецПроцедуры // ПередЗаписью()
	
Процедура ПриЗаписи(Отказ)
		
	Если ОбменДанными.Загрузка Тогда
		Возврат;			
	КонецЕсли; 
		
	бит_ук_СлужебныйСервер.РегистрацияПриЗаписи(Отказ, ЭтотОбъект.ДополнительныеСвойства, Метаданные().ПолноеИмя());
		
КонецПроцедуры // ПриЗаписи()

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ПроверитьНаДубли(Отказ)
		
	// Проверим на дубли по регистрам, а заодно сделаем защиту от копирования.	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	Реквизиты.Регистр
	|ИЗ
	|	Справочник.бит_СтруктураКонструктораДвижений КАК Реквизиты
	|ГДЕ
	|	Реквизиты.Ссылка <> &Ссылка
	|	И Реквизиты.Регистр = &Регистр
	|	И НЕ Реквизиты.ПометкаУдаления";
	
	Запрос.УстановитьПараметр("Регистр", Регистр);
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	
	РезультатЗапроса = Запрос.Выполнить();
	Если НЕ РезультатЗапроса.Пустой() Тогда
		
		ТекстСообщения = СтрШаблон(Нстр("ru = 'Настройка конструктора для регистра ""%1"" уже введена.'"), Регистр); 				   
		ТекстСообщения = ОбщегоНазначенияКлиентСервер.ТекстОшибкиЗаполнения("ПОЛЕ"
													,"КОРРЕКТНОСТЬ"
													,"Регистр"
													,
													,
													,ТекстСообщения);
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстСообщения
													,
													,"Регистр"
													,"Объект"
													,Отказ);
		
	КонецЕсли;

КонецПроцедуры

#КонецОбласти

#КонецЕсли
