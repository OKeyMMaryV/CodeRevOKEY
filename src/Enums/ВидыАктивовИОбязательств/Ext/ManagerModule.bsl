﻿#Область ПрограммныйИнтерфейс

// Определяет перечень видов налоговых активов, соответствующих неиспользованным налоговым убыткам (вычетам),
// подлежащим переносу на будущее в соответствии с IAS12.34-36 и аналогичными положениями ПБУ18.11.
// Соответствующие налоговые активы не рассчитываются исходя из сумм временных разниц.
//
// 
// Возвращаемое значение:
//  ФиксированныйМассив - значения перечисления, соответствующие неиспользованным налоговым убыткам и вычетам.
//
Функция НеиспользованныеНалоговыеУбыткиВычеты() Экспорт
	
	НеиспользованныеНалоговыеУбыткиВычеты = Новый Массив;
	НеиспользованныеНалоговыеУбыткиВычеты.Добавить(УбытокТекущегоПериода);
	// Для учета убытка, перенесенного на будущие периоды (убытка прошлых периодов),
	// отражается специальный (служебный) расход будущих периодов и на ту же сумму вычитаемая временная разница.
	// В результате по таким убыткам признается отложенный налоговый актив вида РасходыБудущихПериодов.
	// В одной из будущих версий предполагается сделать для этой задачи отдельный вид отложенного налогового актива.
	Возврат Новый ФиксированныйМассив(НеиспользованныеНалоговыеУбыткиВычеты);
	
КонецФункции

// Отложенные налоговые активы и обязательства неопределенного в программе вида относятся на служебный вид активов и обязательств.
//
Функция ВидПрочие() Экспорт
	
	Возврат ПрочиеРасходы;
	
КонецФункции

#КонецОбласти
