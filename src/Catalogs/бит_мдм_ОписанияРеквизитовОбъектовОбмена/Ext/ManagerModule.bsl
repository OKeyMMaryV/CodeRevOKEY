﻿#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныйПрограммныйИнтерфейс
	
// Функция выполняет поиск описания реквизита объекта обмена.
// 
// Параметры:
//  ОписаниеОбъекта - СправочникСсылка.бит_мдм_ОписанияОбъектовОбмена.
//  Имя             - Строка - имя элемента.
// 
// Возвращаемое значение:
//  НайденныйЭлемент - СправочникСсылка.бит_мдм_ОписаниеРеквизтовОбъектовОбмена.
// 
Функция НайтиЭлемент(ОписаниеОбъекта, Имя) Экспорт

	НайденныйЭлемент = Справочники.бит_мдм_ОписанияРеквизитовОбъектовОбмена.ПустаяСсылка();
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ОписаниеОбъекта", ОписаниеОбъекта);
	Запрос.УстановитьПараметр("Имя"            , Имя);
	Запрос.Текст = 
    "ВЫБРАТЬ
    |	ТабСпр.Ссылка
    |ИЗ
    |	Справочник.бит_мдм_ОписанияРеквизитовОбъектовОбмена КАК ТабСпр
    |ГДЕ
    |	ТабСпр.Владелец = &ОписаниеОбъекта
    |	И ТабСпр.Имя = &Имя";
				   
	Результат = Запрос.Выполнить();
	Выборка = Результат.Выбрать();
	
	Если Выборка.Следующий() Тогда	
		НайденныйЭлемент = Выборка.Ссылка;	
	КонецЕсли; 

	Возврат НайденныйЭлемент;
	
КонецФункции // НайтиЭлемент()

#КонецОбласти
 
#КонецЕсли
