﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ОбработчикиСобытий

// Процедура - обработчик события "ОбработкаПроведения".
// 
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = бит_ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	
	// Проверка ручной корректировки
	Если бит_ОбщегоНазначения.РучнаяКорректировкаОбработкаПроведения(РучнаяКорректировка,Отказ,Заголовок,ЭтотОбъект, Ложь) Тогда
		Возврат
	КонецЕсли;
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли; 
	
	СтруктураШапкиДокумента = бит_ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	
	СтруктураТаблиц = ПодготовитьТаблицыДокумента();
	
	Если НЕ Отказ Тогда
		ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок);
	КонецЕсли; 
	
КонецПроцедуры

// Процедура - обработчик события "ОбработкаУдаленияПроведения".
// 
Процедура ОбработкаУдаленияПроведения(Отказ)
	
	бит_ОбщегоНазначения.УдалитьДвиженияРегистратора(ЭтотОбъект, Отказ, РучнаяКорректировка);

КонецПроцедуры

// Процедура - обработчик события "ПередЗаписью".
// 
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
 
	
	// Выполним синхронизацию пометки на удаление объекта и дополнительных файлов.
	бит_ХранениеДополнительнойИнформации.СинхронизацияПометкиНаУдалениеУДополнительныхФайлов(ЭтотОбъект);
	
КонецПроцедуры // ПередЗаписью()

Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда
		// В случае выполнения обмена данными не производить проверку.
		Возврат;			
	КонецЕсли; 
		
	 
	
КонецПроцедуры // ПриЗаписи()

Процедура ОбработкаЗаполнения(ДанныеЗаполнения, СтандартнаяОбработка)
	
	ЗаполнитьШапкуДокумента();
	
КонецПроцедуры

Процедура ПриКопировании(ОбъектКопирования)
	
	ЗаполнитьШапкуДокумента(ОбъектКопирования);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область ПроцедурыИФункцииОбщегоНазначения

Процедура ЗаполнитьШапкуДокумента(ОбъектКопирования=Неопределено)
	
	НовыйВидОперации = ВидОперации;
	
	// Заполним шапку документа значениями по умолчанию.
	бит_ОбщегоНазначения.ЗаполнитьШапкуДокумента(ЭтотОбъект, бит_ОбщиеПеременныеСервер.ЗначениеПеременной("глТекущийПользователь"), ОбъектКопирования);

	Если НЕ ЗначениеЗаполнено(НовыйВидОперации) Тогда
		// Если этого не сделать, то при создании нового система не предложит выбрать вид операции.
		ВидОперации = НовыйВидОперации;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ПроцедурыИФункцииДляОбеспеченияПроведенияДокумента

// Функция готовит таблицы документа для проведения.
// 
// Возвращаемое значение:
//   ТаблицаБДДС   - ТаблицаЗначений.
// 
Функция ПодготовитьТаблицыДокумента()  Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Ссылка",Ссылка);
	
	// Адаптация для ERP. Начало. 18.03.2014{{
	ИмяСправочникОсновныеСредства = бит_ОбщегоНазначения.ПолучитьИмяСправочникаОсновныеСредства();
	// Адаптация для ERP. Конец. 18.03.2014}}

	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВЫБОР
				   // Адаптация для ERP. Начало. 18.03.2014{{
	               |		КОГДА ТабЧасть.ОбъектВНА ССЫЛКА Справочник."+ ИмяСправочникОсновныеСредства +"
				   // Адаптация для ERP. Конец. 18.03.2014}}
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.бит_му_ВидыВНА.ОС)
	               |		КОГДА ТабЧасть.ОбъектВНА ССЫЛКА Справочник.НематериальныеАктивы
	               |			ТОГДА ЗНАЧЕНИЕ(Перечисление.бит_му_ВидыВНА.НМА)
	               |	КОНЕЦ КАК ВидВНА,
	               |	ТабЧасть.Ссылка.Организация,
	               |	ТабЧасть.ОбъектВНА,
	               |	СУММА(ТабЧасть.Количество) КАК Количество
	               |ИЗ
	               |	Документ.бит_му_ВыработкаВНА.ВНА КАК ТабЧасть
	               |ГДЕ
	               |	ТабЧасть.Ссылка = &Ссылка
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	ТабЧасть.ОбъектВНА,
	               |	ТабЧасть.Ссылка.Организация";
				   
    Результат = Запрос.Выполнить();				   
	
	СтруктураТаблиц = Новый Структура;
	СтруктураТаблиц.Вставить("ВНА",Результат.Выгрузить());
	
	Возврат СтруктураТаблиц;

КонецФункции // ПодготовитьТаблицуБДДС()

// Процедура выполняет движения по регистрам.
//                
Процедура ДвиженияПоРегистрам(СтруктураШапкиДокумента,СтруктураТаблиц,Отказ,Заголовок)
	
	// Движения по регистру накопления бит_му_ВыработкаОС.
	НаборДвижений = Движения.бит_му_ВыработкаВНА;
	
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	ТаблицаДвижений.Очистить();
	
	Для каждого СтрокаТаблицы Из СтруктураТаблиц.ВНА Цикл
		
		СтрокаДвижений = ТаблицаДвижений.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаДвижений,СтрокаТаблицы);
	
	КонецЦикла; 
	
	НаборДвижений.мПериод          = СтруктураШапкиДокумента.Дата;
	НаборДвижений.мТаблицаДвижений = ТаблицаДвижений;
	НаборДвижений.ДобавитьДвижение();
	
КонецПроцедуры // ДвиженияПоРегистрам()

#КонецОбласти

#КонецОбласти

#КонецЕсли
